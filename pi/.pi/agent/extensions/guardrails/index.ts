/**
 * Guardrails: confirma o bloquea llamadas a tools peligrosas antes de ejecutarlas.
 *
 * No es un sandbox: protege de accidentes, no de un agente que quiera rodearlo.
 * Diseño: docs/design/agent-guardrails.md del repo dotfiles.
 */
import * as os from "node:os";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { classify, type Verdict } from "./rules.ts";

const AVOID_BYPASS = "No lo reintentes por otra vía; pídeselo al usuario.";

export default function (pi: ExtensionAPI) {
	pi.on("tool_call", async (event, ctx) => {
		const input = event.input as Record<string, unknown>;
		let verdict: Verdict;
		try {
			verdict = classify(event.toolName, input, { cwd: ctx.cwd, home: os.homedir() });
		} catch (error) {
			return { block: true, reason: `Error interno de guardrails (${String(error)}). ${AVOID_BYPASS}` };
		}

		if (verdict.action === "allow") return undefined;
		if (verdict.action === "block") return { block: true, reason: `Bloqueado: ${verdict.reason}. ${AVOID_BYPASS}` };
		if (!ctx.hasUI) {
			return { block: true, reason: `Bloqueado: ${verdict.reason}; requiere confirmación y no hay UI. ${AVOID_BYPASS}` };
		}

		const ok = await ctx.ui.confirm(`⚠️ Guardrails: ${verdict.reason}`, String(input.command ?? input.path));
		return ok ? undefined : { block: true, reason: `Rechazado por el usuario: ${verdict.reason}. ${AVOID_BYPASS}` };
	});
}
