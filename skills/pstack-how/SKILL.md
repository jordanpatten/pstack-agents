---
name: pstack-how
description: Explain how a subsystem works, walk through code before changing it, and answer placement and ownership questions ("where should this live", "which module owns this", "is this the right layer"). Use why for motivation.
disable-model-invocation: true
---

# How

Explore the codebase to answer "how does X work?" Produce an architectural explanation at the level of a senior engineer onboarding onto a subsystem. Give enough to build a working mental model, not so much that it reads like annotated source.

Every spawn is a read-only subagent. Explorers run on the worker model. The explainer runs on the judgment model. Role-to-model mapping for your tool is in `../pstack/harness.md`.

## 1. Assess complexity

If the scope is ambiguous, state your interpretation and explore. The user can redirect.

- **Simple** (one module, a small utility, a narrow question such as "how does function X work"): no explorers. Spawn one explainer that explores and explains in one pass, built from `explainer-prompt.md` in this directory without the explorer-findings section. Go to step 4.
- **Complex** (a subsystem across several files or services, a cross-cutting feature, a full architectural overview): go to step 2.

When in doubt, take the simple path.

## 2. Explore (complex only)

Split the question into 2 to 4 angles, each a distinct slice of the subsystem. Spawn all explorers in one message. Build each explorer's prompt from `explorer-prompt.md` in this directory, with its angle and the original question filled in.

## 3. Synthesize (complex only)

Once every explorer has returned, spawn one explainer built from `explainer-prompt.md` with every explorer's findings filled in.

## 4. Present

Present the explainer's output. Light edits for clarity or context from the conversation are fine. Do not substantially rewrite it.

## Output format

The explanation uses the sections in `explainer-prompt.md`, dropping any that do not apply: Overview, Key Concepts, How It Works, Where Things Live, Gotchas.
