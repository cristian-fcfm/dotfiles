import { test } from "node:test";
import assert from "node:assert/strict";
import { buildArgs, loadAgent, runTask, runTasks, toAgent } from "./core.ts";

const explorador = toAgent(
	{ name: "explorador", description: "d", tools: "read, grep, bash", model: "p/m", thinking: "low" },
	"Eres un explorador.",
);

const load = () => explorador;

test("toAgent: la lista de tools se separa por comas y se recorta", () => {
	assert.deepEqual(explorador.tools, ["read", "grep", "bash"]);
});

test("buildArgs: modo print sin sesión, tools acotadas y prompt del agente", () => {
	const args = buildArgs(explorador, "cuenta ficheros");
	const after = (flag: string) => args[args.indexOf(flag) + 1];
	assert.ok(args.includes("-p") && args.includes("--no-session"));
	assert.equal(after("--tools"), "read,grep,bash");
	assert.equal(after("--model"), "p/m");
	assert.equal(after("--thinking"), "low");
	assert.equal(after("--append-system-prompt"), "Eres un explorador.");
});

test("buildArgs: la tarea va al final con prefijo para que nunca se lea como flag", () => {
	const args = buildArgs(explorador, "--help");
	assert.equal(args.at(-1), "Tarea:\n--help");
});

test("runTask: devuelve el stdout del hijo y lo lanza con buildArgs", async () => {
	let seen: string[] = [];
	const r = await runTask(async (_c, args) => ((seen = args), { stdout: "hola", stderr: "", code: 0 }), explorador, "t", {});
	assert.deepEqual(r, { ok: true, text: "hola" });
	assert.deepEqual(seen, buildArgs(explorador, "t"));
});

const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));

test("runTasks paralelo: 2 tareas tardan ≈ la más lenta, no la suma", async () => {
	const exec = async (_c: string, args: string[]) => {
		await sleep(150);
		return { stdout: args.at(-1)!, stderr: "", code: 0 };
	};
	const t0 = Date.now();
	await runTasks(exec, load, [{ agent: "explorador", task: "a" }, { agent: "explorador", task: "b" }], {});
	const ms = Date.now() - t0;
	assert.ok(ms < 250, `tardó ${ms} ms`);
});

test("runTasks: un bloque por tarea, en el orden pedido aunque terminen al revés", async () => {
	const exec = async (_c: string, args: string[]) => {
		const task = args.at(-1)!;
		await sleep(task.endsWith("lenta") ? 80 : 0);
		return { stdout: `salida ${task.slice(7)}`, stderr: "", code: 0 };
	};
	const { text } = await runTasks(exec, load, [{ agent: "explorador", task: "lenta" }, { agent: "explorador", task: "rapida" }], {});
	assert.equal(text, "### explorador (1/2)\nsalida lenta\n\n### explorador (2/2)\nsalida rapida");
});

const fm = (over: Record<string, unknown> = {}) => ({ name: "x", description: "d", tools: "read, grep", ...over });
const reader = (parsed?: { frontmatter: Record<string, unknown>; body: string }) => () => parsed;
const loadErr = (name: string, parsed?: { frontmatter: Record<string, unknown>; body: string }) => () => loadAgent(name, reader(parsed));

test("loadAgent: un agente válido se carga", () => {
	const a = loadAgent("x", reader({ frontmatter: fm(), body: "prompt" }));
	assert.deepEqual([a.name, a.tools, a.body], ["x", ["read", "grep"], "prompt"]);
});

test("loadAgent: nombre fuera de ^[a-z0-9-]+$ se rechaza sin leer nada", () => {
	let leyó = false;
	const read = () => ((leyó = true), undefined);
	for (const name of ["../x", "a/b", "X", "", "a b"]) assert.throws(() => loadAgent(name, read), /nombre.*inválido/);
	assert.equal(leyó, false);
});

test("loadAgent: agente inexistente", () => {
	assert.throws(loadErr("nope"), /nope.*no existe/);
});

test("loadAgent: frontmatter incompleto se rechaza", () => {
	const ok = { frontmatter: fm(), body: "prompt" };
	assert.throws(loadErr("x", { ...ok, frontmatter: fm({ tools: undefined }) }), /tools/);
	assert.throws(loadErr("x", { ...ok, frontmatter: fm({ tools: " , " }) }), /tools/);
	assert.throws(loadErr("x", { ...ok, frontmatter: fm({ description: undefined }) }), /description/);
	assert.throws(loadErr("x", { ...ok, frontmatter: fm({ name: "otro" }) }), /name/);
	assert.throws(loadErr("x", { ...ok, body: "  \n" }), /cuerpo/);
});

test("loadAgent: tools que dan escritura o recursión se rechazan", () => {
	for (const tool of ["subagent", "write", "edit"]) {
		assert.throws(loadErr("x", { frontmatter: fm({ tools: `read, ${tool}` }), body: "p" }), new RegExp(`${tool}.*prohib`));
	}
});

test("runTasks no lanza ningún hijo si alguna tarea tiene un agente inválido", async () => {
	let lanzados = 0;
	const exec = async () => (lanzados++, { stdout: "", stderr: "", code: 0 });
	const loadSome = (name: string) => (name === "explorador" ? explorador : loadAgent(name, reader()));
	await assert.rejects(
		runTasks(exec, loadSome, [{ agent: "explorador", task: "a" }, { agent: "nope", task: "b" }], {}),
		/nope.*no existe/,
	);
	assert.equal(lanzados, 0);
});

test("buildArgs hereda: sin model/thinking en el agente usa los de la sesión", () => {
	const revisor = toAgent({ name: "revisor", description: "d", tools: "read" }, "p");
	const args = buildArgs(revisor, "t", { model: "prov/modelo", thinking: "high" });
	assert.equal(args[args.indexOf("--model") + 1], "prov/modelo");
	assert.equal(args[args.indexOf("--thinking") + 1], "high");
});

test("buildArgs hereda: lo que declara el agente gana sobre la sesión", () => {
	const args = buildArgs(explorador, "t", { model: "prov/modelo", thinking: "high" });
	assert.equal(args[args.indexOf("--model") + 1], "p/m");
	assert.equal(args[args.indexOf("--thinking") + 1], "low");
});

test("buildArgs hereda: sin modelo en ninguno de los dos no pasa --model", () => {
	const revisor = toAgent({ name: "revisor", description: "d", tools: "read" }, "p");
	const args = buildArgs(revisor, "t", {});
	assert.ok(!args.includes("--model") && !args.includes("--thinking"));
});

test("runTasks pasa el modelo de la sesión a cada hijo", async () => {
	const seen: string[][] = [];
	const exec = async (_c: string, args: string[]) => (seen.push(args), { stdout: "", stderr: "", code: 0 });
	const sinModelo = () => toAgent({ name: "revisor", description: "d", tools: "read" }, "p");
	await runTasks(exec, sinModelo, [{ agent: "revisor", task: "a" }], { model: "prov/modelo", thinking: "medium" });
	assert.equal(seen[0][seen[0].indexOf("--model") + 1], "prov/modelo");
	assert.equal(seen[0][seen[0].indexOf("--thinking") + 1], "medium");
});

const ok = (stdout: string) => ({ stdout, stderr: "", code: 0 });
const un = (task: string) => [{ agent: "explorador", task }];

test("runTask: la salida de más de 16 KB llega truncada por la cabeza y con marca", async () => {
	const r = await runTask(async () => ok("a".repeat(16 * 1024) + "FINAL"), explorador, "t", {});
	assert.ok(r.text.startsWith("a".repeat(16 * 1024)));
	assert.ok(!r.text.includes("FINAL"));
	assert.match(r.text, /\[salida truncada a 16 KB\]$/);
});

test("runTask: una salida de hasta 16 KB no se toca", async () => {
	const out = "b".repeat(16 * 1024);
	assert.equal((await runTask(async () => ok(out), explorador, "t", {})).text, out);
});

test("runTask: exit ≠ 0 devuelve un bloque de fallo con los últimos 2 KB de stderr", async () => {
	const stderr = "x".repeat(5000) + "FIN";
	const r = await runTask(async () => ({ stdout: "", stderr, code: 2 }), explorador, "t", {});
	assert.equal(r.ok, false);
	assert.match(r.text, /^falló \(exit 2\)\n/);
	assert.ok(r.text.endsWith("x".repeat(2045) + "FIN"));
	assert.ok(r.text.length < 2100);
});

test("runTask: timeout de 10 min al exec; si pi lo mata sin abortar es «timeout»", async () => {
	let opts: Record<string, unknown> = {};
	const exec = async (_c: string, _a: string[], o: Record<string, unknown>) => ((opts = o), { stdout: "", stderr: "", code: 143, killed: true });
	const r = await runTask(exec, explorador, "t", {});
	assert.equal(opts.timeout, 10 * 60 * 1000);
	assert.deepEqual(r, { ok: false, text: "falló: timeout (10 min)" });
});

test("runTask: si el usuario aborta es «cancelado»", async () => {
	const ctl = new AbortController();
	ctl.abort();
	const r = await runTask(async () => ({ stdout: "", stderr: "", code: 143, killed: true }), explorador, "t", { signal: ctl.signal });
	assert.deepEqual(r, { ok: false, text: "cancelado" });
});

test("runTask: si pi no arranca el error de spawn va en el bloque, no tumba al lote", async () => {
	const r = await runTask(async () => { throw new Error("spawn pi ENOENT"); }, explorador, "t", {});
	assert.deepEqual(r, { ok: false, text: "falló: spawn pi ENOENT" });
});

test("runTasks: un hijo que falla no tumba a los demás; isError solo si fallan todos", async () => {
	const exec = async (_c: string, args: string[]) => (args.at(-1)!.endsWith("mal") ? { stdout: "", stderr: "boom", code: 1 } : ok("bien"));
	const parcial = await runTasks(exec, load, [...un("mal"), ...un("ok")], {});
	assert.equal(parcial.isError, false);
	assert.equal(parcial.text, "### explorador (1/2)\nfalló (exit 1)\nboom\n\n### explorador (2/2)\nbien");
	assert.equal((await runTasks(exec, load, [...un("mal"), ...un("mal")], {})).isError, true);
	assert.equal((await runTasks(exec, load, un("ok"), {})).isError, false);
});

test("runTask: un corte de 16 KB que parte un carácter multibyte no deja \uFFFD", async () => {
	const out = "€".repeat(6000);
	const r = await runTask(async () => ok(out), explorador, "t", {});
	const cuerpo = r.text.replace(/\n\[salida truncada a 16 KB\]$/, "");
	assert.ok(!r.text.includes("\uFFFD"));
	assert.ok(out.startsWith(cuerpo));
});

test("runTask: salida desbordada (maxBuffer) no se diagnostica como timeout", async () => {
	const r = await runTask(async () => ({ stdout: "x", stderr: "", code: 143, killed: true, truncated: true }), explorador, "t", {});
	assert.equal(r.ok, false);
	assert.match(r.text, /límite de salida/);
});

test("runTask: si exec rechaza porque se abortó, es «cancelado»", async () => {
	const ctl = new AbortController();
	const exec = async () => { ctl.abort(); throw new Error("aborted"); };
	assert.deepEqual(await runTask(exec, explorador, "t", { signal: ctl.signal }), { ok: false, text: "cancelado" });
});

test("runTask: con el signal ya abortado no lanza ningún hijo", async () => {
	const ctl = new AbortController();
	ctl.abort();
	let lanzados = 0;
	const r = await runTask(async () => (lanzados++, ok("x")), explorador, "t", { signal: ctl.signal });
	assert.equal(lanzados, 0);
	assert.deepEqual(r, { ok: false, text: "cancelado" });
});
