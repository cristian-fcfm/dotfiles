/** Agente de solo lectura ya leído de `agents/<nombre>.md`. */
export type Agent = {
	name: string;
	description: string;
	tools: string[];
	model?: string;
	thinking?: string;
	body: string;
};

/** Opciones de un lote: dónde y cómo lanzar los hijos, y el modelo/thinking de la sesión que heredan. */
export type Opts = { cwd?: string; signal?: AbortSignal; model?: string; thinking?: string };

/** Función que lanza un comando sin shell; es `pi.exec` en producción y un falso en los tests. */
export type Exec = (
	cmd: string,
	args: string[],
	opts: { cwd?: string; signal?: AbortSignal; timeout?: number },
) => Promise<{ stdout: string; stderr: string; code: number; killed?: boolean; truncated?: boolean }>;

const MAX_OUT = 16 * 1024;
const MAX_ERR = 2 * 1024;
const TIMEOUT_MS = 10 * 60 * 1000;

/**
 * Construye un `Agent` a partir del frontmatter y el cuerpo de su `.md`.
 *
 * @param fm frontmatter ya parseado; `tools` es una lista separada por comas.
 * @param body cuerpo del fichero, que será el prompt de sistema del hijo.
 */
export function toAgent(fm: Record<string, unknown>, body: string): Agent {
	const tools = String(fm.tools ?? "").split(",").map((t) => t.trim()).filter(Boolean);
	return {
		name: String(fm.name),
		description: String(fm.description),
		tools,
		model: typeof fm.model === "string" ? fm.model : undefined,
		thinking: typeof fm.thinking === "string" ? fm.thinking : undefined,
		body,
	};
}

const FORBIDDEN_TOOLS = ["subagent", "write", "edit"];

/**
 * Carga y valida el agente `name`; lanza un error con el motivo si no se puede usar.
 *
 * @param name nombre del agente; debe casar `^[a-z0-9-]+$` (no sale del directorio de agentes).
 * @param read devuelve el frontmatter y el cuerpo ya parseados de `agents/<name>.md`, o `undefined` si no existe.
 */
export function loadAgent(
	name: string,
	read: (name: string) => { frontmatter: Record<string, unknown>; body: string } | undefined,
): Agent {
	if (!/^[a-z0-9-]+$/.test(name)) throw new Error(`nombre de agente inválido: "${name}"`);
	const parsed = read(name);
	if (!parsed) throw new Error(`el agente "${name}" no existe`);
	const { frontmatter: fm, body } = parsed;
	if (fm.name !== name) throw new Error(`agente "${name}": el campo name debe ser "${name}"`);
	if (typeof fm.description !== "string" || !fm.description.trim()) throw new Error(`agente "${name}": falta description`);
	if (!body.trim()) throw new Error(`agente "${name}": falta el cuerpo (prompt)`);
	const agent = toAgent(fm, body);
	if (agent.tools.length === 0) throw new Error(`agente "${name}": falta tools`);
	const bad = agent.tools.find((t) => FORBIDDEN_TOOLS.includes(t));
	if (bad) throw new Error(`agente "${name}": la tool ${bad} está prohibida en subagentes`);
	return agent;
}

/**
 * Argumentos de `pi` para lanzar `agent` sobre `task`.
 *
 * `model` y `thinking` del agente ganan sobre los de la sesión (`session`); la tarea lleva
 * prefijo para no leerse como flag.
 */
export function buildArgs(agent: Agent, task: string, session: Pick<Opts, "model" | "thinking"> = {}): string[] {
	const args = ["-p", "--no-session", "--tools", agent.tools.join(",")];
	const model = agent.model ?? session.model;
	const thinking = agent.thinking ?? session.thinking;
	if (model) args.push("--model", model);
	if (thinking) args.push("--thinking", thinking);
	args.push("--append-system-prompt", agent.body, `Tarea:\n${task}`);
	return args;
}

/**
 * Lanza un hijo `pi` con `agent`; nunca lanza: un fallo es un resultado con `ok: false`.
 *
 * @returns `text` es el stdout (cabeza de 16 KB, con marca si se truncó) o el motivo del fallo
 * (exit con los últimos 2 KB de stderr, timeout de 10 min, límite de salida, cancelado o error de spawn).
 */
export async function runTask(exec: Exec, agent: Agent, task: string, opts: Opts): Promise<{ ok: boolean; text: string }> {
	const { model, thinking, ...execOpts } = opts;
	if (opts.signal?.aborted) return { ok: false, text: "cancelado" };
	try {
		const r = await exec("pi", buildArgs(agent, task, { model, thinking }), { ...execOpts, timeout: TIMEOUT_MS });
		if (opts.signal?.aborted) return { ok: false, text: "cancelado" };
		if (r.truncated) return { ok: false, text: "falló: la salida superó el límite de salida de pi" };
		if (r.killed) return { ok: false, text: "falló: timeout (10 min)" };
		if (r.code !== 0) return { ok: false, text: `falló (exit ${r.code})\n${r.stderr.slice(-MAX_ERR)}` };
		const out = Buffer.from(r.stdout);
		const cut = out.length > MAX_OUT ? `${out.subarray(0, MAX_OUT).toString().replace(/\uFFFD$/, "")}\n[salida truncada a 16 KB]` : r.stdout;
		return { ok: true, text: cut };
	} catch (e) {
		if (opts.signal?.aborted) return { ok: false, text: "cancelado" };
		return { ok: false, text: `falló: ${e instanceof Error ? e.message : String(e)}` };
	}
}

/**
 * Valida todos los agentes y, solo entonces, lanza las tareas a la vez.
 *
 * Devuelve un bloque `### agente (i/n)` por tarea, en el orden pedido; un hijo que falla no
 * tumba a los demás y `isError` solo es true si fallan todos. Si `load` lanza para cualquier
 * tarea, no se lanza ningún hijo.
 */
export async function runTasks(
	exec: Exec,
	load: (name: string) => Agent,
	tasks: { agent: string; task: string }[],
	opts: Opts,
): Promise<{ text: string; isError: boolean }> {
	const loaded = tasks.map((t) => ({ agent: load(t.agent), task: t.task }));
	const rs = await Promise.all(loaded.map((t) => runTask(exec, t.agent, t.task, opts)));
	return {
		text: rs.map((r, i) => `### ${loaded[i].agent.name} (${i + 1}/${rs.length})\n${r.text}`).join("\n\n"),
		isError: rs.every((r) => !r.ok),
	};
}
