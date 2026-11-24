import * as path from "node:path";

/** Veredicto de una llamada a tool: dejarla pasar, preguntar al usuario o bloquearla. */
export type Verdict = { action: "allow" } | { action: "confirm" | "block"; reason: string };

/** Entorno contra el que se resuelven las rutas; se inyecta para no depender de la máquina. */
export type Env = { cwd: string; home: string };

const ALLOW: Verdict = { action: "allow" };

// Sin cruzar ; & | ni salto de línea: el resto del mismo comando de una cadena.
const SAME_CMD = String.raw`[^;&|\n]*`;

/**
 * `git`, sus opciones globales (`-C dir`, `-c k=v`, `--no-pager`) y el subcomando dado.
 *
 * Cada opción casa de una sola forma; si una pudiera leerse de dos (`--x` como
 * `-`+`-x` o `--`+`x`) el backtracking sería exponencial y colgaría pi.
 */
const git = (sub: string) =>
	new RegExp(String.raw`\bgit(?:\s+(?:-[Cc]\s+[^\s-]\S*|--?\w[\w-]*(?:=\S+)?))*\s+` + sub);

const BASH_RULES: Array<[RegExp, string]> = [
	[git(String.raw`push\b`), "publica fuera de la máquina (git push)"],
	[/\bgh\s+pr\s+(?:create|merge)\b/, "publica fuera de la máquina (gh pr)"],
	[git(String.raw`reset\b${SAME_CMD}\s--hard\b`), "descarta cambios (git reset --hard)"],
	[git(String.raw`clean\b${SAME_CMD}\s(?:-[a-zA-Z]*f|--force\b)`), "borra ficheros no rastreados (git clean -f)"],
	[git(String.raw`branch\b${SAME_CMD}\s(?:-[a-zA-Z]*[Df]|--force\b)`), "borra o mueve una rama a la fuerza (git branch -D/--force)"],
	[git(String.raw`(?:checkout|restore)(?:\s+--)?\s+\.(?=\s|$|[;&|])`), "descarta cambios del árbol de trabajo"],
	[/\bsudo\b/, "ejecuta con privilegios de root (sudo)"],
	[new RegExp(String.raw`\brm\s+(?:${SAME_CMD}\s)?(?:-[a-zA-Z]*[rR][a-zA-Z]*|--recursive)\b`), "borrado recursivo (rm -r)"],
];

/**
 * Clasifica una llamada a tool del agente según las reglas de guardrails.
 *
 * Args:
 *   tool: nombre de la tool (`bash`, `read`, `write`, `edit`…).
 *   input: argumentos de la llamada tal como los recibe la tool.
 *   env: directorio de trabajo y home para resolver rutas relativas y `~`.
 *
 * Returns:
 *   `allow`, o `confirm`/`block` con el motivo que verán el usuario y el agente.
 */
export function classify(tool: string, input: Record<string, unknown>, env: Env): Verdict {
	if (tool === "bash") return classifyCommand(input.command);
	if (tool === "read" || tool === "write" || tool === "edit") return classifyPath(tool, input.path, env);
	return ALLOW;
}

function classifyCommand(command: unknown): Verdict {
	if (typeof command !== "string") return ALLOW;
	const hit = BASH_RULES.find(([pattern]) => pattern.test(command));
	return hit ? { action: "confirm", reason: hit[1] } : ALLOW;
}

function classifyPath(tool: string, rawPath: unknown, env: Env): Verdict {
	if (typeof rawPath !== "string") return ALLOW;
	const target = resolvePath(rawPath, env);
	const secret = isSecret(target, env.home);
	if (tool === "read") return secret ? { action: "confirm", reason: "lee un fichero con secretos" } : ALLOW;
	if (secret) return { action: "block", reason: "escribe en un fichero con secretos" };
	if (target.split(path.sep).includes(".git")) return { action: "block", reason: "escribe dentro de .git/" };
	return ALLOW;
}

function resolvePath(rawPath: string, env: Env): string {
	const expanded = rawPath === "~" || rawPath.startsWith("~/") ? path.join(env.home, rawPath.slice(1)) : rawPath;
	return path.resolve(env.cwd, expanded);
}

function isSecret(target: string, home: string): boolean {
	return (
		/^\.env(\..+)?$/.test(path.basename(target)) ||
		target.startsWith(path.join(home, ".ssh") + path.sep) ||
		target === path.join(home, ".pi", "agent", "auth.json")
	);
}
