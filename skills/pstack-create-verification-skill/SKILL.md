---
name: pstack-create-verification-skill
description: Generate a project-local verification skill that drives your app the way a user does (any language, framework, or platform), with a feature map. Use when a project has no scripted way to prove UI, CLI, or service behavior.
disable-model-invocation: true
---

# Create a verification skill

Every serious project needs a scripted way to drive the real app and prove behavior: launch it, exercise a feature the way a user would, and capture evidence. This skill generates that as a project-local skill at `.claude/skills/verify-<app>/` (Claude Code and Grok Build read it there) or `.agents/skills/verify-<app>/` (Codex and Grok Build), tailored to the repo. Write it for the next agent, not for a human. An agent will read it cold, mid-task, without having seen the app.

## 1. Interview the repo, not the user

Answer these from the codebase. Ask the user only what you cannot observe.

- **Surface.** What does a user touch? A web UI, a CLI or TUI, a desktop app, an API, a mobile app, a library? A repo can have several. Pick the primary one and note the rest.
- **Run.** How does the app start locally? Prefer the repo's documented dev command (package scripts, Makefile, README quickstart). Note ports, env vars, seed data, and auth.
- **Drive.** How can an agent interact with it programmatically? Existing harnesses first: Playwright or Cypress specs, expect scripts, PTY helpers, curl-able endpoints, a debug port. Only then pick a generic recipe: a browser or CDP for web and Electron, a tmux or PTY harness for CLI and TUI, plain HTTP for services.
- **Observe.** What evidence can be captured? Screenshots, terminal transcripts, response bodies, logs, exit codes, database state.
- **Isolate.** Can two instances run side by side (ports, data dirs, profiles)? If not, say so in the generated skill. Refusing to double-drive a shared instance beats corrupting the user's session.

If the checkout does not build or start as-is, fix that first, or report it precisely, before you generate anything. A skill written against a broken base teaches wrong steps. When an irrelevant missing asset blocks startup (a static dir the API never serves, a sample config), the generated skill may create it, clearly marked as verification scaffolding, and remove it in cleanup.

## 2. Generate the skill

Write `.claude/skills/verify-<app>/SKILL.md` with YAML frontmatter (`name: verify-<app>` and a `description` that names the app, the surface, and when to use it) and these sections, each grounded in what the interview found. Leave no placeholders.

- **Launch.** The exact command that starts the app for verification, and how to tell it is ready (a log line, a prompt). Launch must reach a usable state from an empty data dir, including migrations and seed data. Ready means usable, not just that a process answers. A database health check can pass while its init scripts still run. Include teardown. For a short-lived CLI or TUI there is no server to keep alive. Launch means build the binary (or install dependencies) once, then start each drive in its own isolated PTY or tmux session.
- **Doctor.** One read-only check that answers "is this instance worth driving?": process up, right version, port owned by us, auth valid. An agent runs it first whenever anything looks off.
- **Drive.** The harness recipe with real selectors and commands from this repo, not examples. Prefer stable handles (ARIA labels, data attributes, prompt strings, route paths) over coordinates and tab order.
- **Evidence.** What to capture for a proof and where it goes. State the proof standards. Exercise the real user path, not internal setters or test-only endpoints. Capture the action and the resulting state, not just the final screen. Verify side effects (files written, rows inserted, messages sent) alongside what is visible. Use mocks only where a production boundary already isolates the external system. When the safe path is a dry-run or test mode, verify what it actually skips by observing (files, network, git refs), because some dry-runs still touch the network.
- **Cleanup.** How to tear down what the run created. Never kill by process name. Kill what you started. Cleanup removes instances and scratch state, never the evidence. Proof artifacts survive the teardown in a location the skill names.
- **Helpers.** Any script the skill ships is executable, and the skill body shows how to call it.

## 3. Seed the feature map

Create `.claude/skills/verify-<app>/features/README.md` plus one file per user-facing feature you can identify (start with the top 3 to 5, from routes, commands, menus, or docs). The README is an index. Each feature file answers, from the user's point of view, what the feature is, how to reach it, how to drive it with the harness, and what observable end state proves it works. Use four H2s: `Sub-features`, `How to get to it (user POV)`, `Driving it with <harness>`, and `Gotchas`. If the seed data lacks a precondition a journey needs, the journey reports a failure and the reason goes in that feature's `Gotchas`. Never weaken the journey to make it pass. A proof that drives one convenient entry point is incomplete when the map lists others.

## 4. Prove the generated skill before you hand it over

Run its own instructions end to end once: launch, doctor, drive ONE mapped feature, capture evidence, clean up. After cleanup, confirm the evidence still exists at the named location. A cleanup that eats the proof fails this step. Fix what fails, and run the generated cleanup after every failed attempt too, so broken attempts do not strand processes and ports. A generated skill that was never executed is a draft, not a deliverable. If you proved it in a stand-in for the real target (a container instead of a fresh machine), list every setup step the stand-in did that the target will not. Those steps stay unverified.

## 5. Offer upkeep

Tell the user the feature map rots as the app changes. Offer a periodic pass that re-reads each feature from source, drives every feature once live, and ships at most one PR of proven corrections to the map and harness. Never edit product code in that pass. A behavior the map describes that the app no longer does is either doc drift (fix the map) or a product regression (report it).
