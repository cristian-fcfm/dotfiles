/**
 * Subagentes de solo lectura: lanza agentes de `~/.pi/agent/agents/` como procesos `pi -p` hijos.
 *
 * Diseño: docs/design/parallel-subagents.md del repo dotfiles.
 */
import * as fs from "node:fs";
import * as path from "node:path";
import { getAgentDir, parseFrontmatter, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { loadAgent, runTasks } from "./core.ts";

const Params = Type.Object({
	tasks: Type.Array(
		Type.Object({
			agent: Type.String({ description: "Nombre del agente, p. ej. explorador" }),
			task: Type.String({ minLength: 1, description: "Tarea autocontenida: rutas, comandos y qué devolver" }),
		}),
		{ minItems: 1, maxItems: 4 },
	),
});

/** Lee `~/.pi/agent/agents/<name>.md`; `name` ya viene validado por `loadAgent`. */
function readAgentFile(name: string) {
	const file = path.join(getAgentDir(), "agents", `${name}.md`);
	return fs.existsSync(file) ? parseFrontmatter(fs.readFileSync(file, "utf-8")) : undefined;
}

export default function (pi: ExtensionAPI) {
	pi.registerTool({
		name: "subagent",
		label: "Subagent",
		description:
			"Lanza de 1 a 4 subagentes de solo lectura en paralelo, cada uno con contexto limpio. Solo para tareas independientes. No ven esta conversación: `task` lleva rutas, comandos y qué devolver.",
		parameters: Params,
		async execute(_id, params, signal, _onUpdate, ctx) {
			const load = (name: string) => loadAgent(name, readAgentFile);
			const { text, isError } = await runTasks((cmd, args, o) => pi.exec(cmd, args, o), load, params.tasks, {
				cwd: ctx.cwd,
				signal,
				model: ctx.model && `${ctx.model.provider}/${ctx.model.id}`,
				thinking: ctx.thinkingLevel,
			});
			return { content: [{ type: "text", text }], details: undefined, isError };
		},
	});
}
