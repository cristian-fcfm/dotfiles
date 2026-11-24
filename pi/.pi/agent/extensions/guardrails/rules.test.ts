import { test } from "node:test";
import assert from "node:assert/strict";
import { classify } from "./rules.ts";

const env = { cwd: "/repo", home: "/home/u" };

const bash = (command: string) => classify("bash", { command }, env).action;
const onPath = (tool: string, path: string) => classify(tool, { path }, env).action;

test("bash: comandos que publican o destruyen piden confirmación", () => {
	for (const command of [
		"git push origin main",
		"git push --force",
		"git push origin --delete feat/x",
		"cd x && git push",
		"git -C . push",
		"gh pr create --fill",
		"gh pr merge 12",
		"git reset --hard HEAD~1",
		"git clean -fd",
		"git clean -f",
		"git branch -D feat/x",
		"git branch --delete --force feat/x",
		"git branch -d -f feat/x",
		"git checkout .",
		"git checkout -- .",
		"git restore .",
		"sudo ls",
		"rm -rf dir",
		"rm -fr dir",
		"rm -r dir",
		"rm -r -f dir",
		"rm --recursive dir",
	]) {
		assert.equal(bash(command), "confirm", command);
	}
});

test("bash: el resto pasa sin fricción", () => {
	for (const command of [
		"git status",
		"git diff",
		"git log --oneline",
		"git log --grep push",
		"git stash push -m wip",
		"git branch -d feat/x",
		"git branch --format=%(refname)",
		"git checkout main",
		"git restore src/x.ts",
		"git clean -n",
		"rm archivo.tmp",
		"rm -f archivo.tmp",
		"ls -R",
		"echo pushd",
	]) {
		assert.equal(bash(command), "allow", command);
	}
});

const secrets = [".env", "sub/.env.local", "/home/u/.pi/agent/auth.json", "~/.ssh/id_ed25519"];

test("write/edit: secretos y .git/ se bloquean", () => {
	for (const tool of ["write", "edit"]) {
		for (const path of [...secrets, ".git/config", "/repo/sub/.git/HEAD"]) {
			assert.equal(onPath(tool, path), "block", `${tool} ${path}`);
		}
	}
});

test("read: secretos piden confirmación; .git/ no es secreto", () => {
	for (const path of secrets) assert.equal(onPath("read", path), "confirm", path);
	assert.equal(onPath("read", ".git/config"), "allow");
});

test("rutas normales y parecidas a secretos pasan", () => {
	for (const path of ["src/x.ts", ".envrc", ".gitignore", "~/.pi/agent/settings.json"]) {
		assert.equal(onPath("write", path), "allow", path);
		assert.equal(onPath("read", path), "allow", path);
	}
});

test("bash: muchas opciones globales de git no disparan backtracking exponencial", () => {
	const start = performance.now();
	assert.equal(bash(`git ${"--x ".repeat(40)}-C a -C -C status`), "allow");
	assert.equal(bash(`git ${"--x ".repeat(40)}push`), "confirm");
	assert.ok(performance.now() - start < 50, "la clasificación debe ser lineal");
});

test("otras tools e inputs no string pasan", () => {
	assert.equal(classify("grep", { pattern: "x" }, env).action, "allow");
	assert.equal(classify("bash", { command: 42 }, env).action, "allow");
	assert.equal(classify("write", {}, env).action, "allow");
});

test("los veredictos no-allow llevan motivo", () => {
	const verdict = classify("bash", { command: "git push" }, env);
	assert.ok(verdict.action !== "allow" && verdict.reason.length > 0);
});
