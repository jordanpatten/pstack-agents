---
name: pstack-architect
description: Sketch the caller's usage, types, signatures, and module structure before code, from at least two competing designs, then implement against the chosen sketch. Use for "architect this", "design this", or nontrivial work where jumping to code would lock in the wrong shape.
disable-model-invocation: true
---

# Architect

Sketch types, function signatures, class shapes, and module boundaries with `not implemented` bodies and pseudocode. Synthesize across several model perspectives, then fill in code against the chosen sketch.

Open a todo list with one entry per phase: Ground, Sketch, Agree, Implement, Scrap.

## Phase A. Ground the problem

Build a real model of every system the new code touches. Run **how** over the relevant subsystems. Naming a file is not grounding. If the design redefines ownership or layering, also run **why** on the existing shape, so the rationale becomes a constraint, not a guess. Skip Phase A only for greenfield work with no surrounding system.

## Phase B. Sketch

Run **arena** with the design-sketch task and the Phase A grounding. Pass `runner-prompt.md` from this directory as each runner's prompt. Runners are the panel models from `../pstack/harness.md`.

Design it twice. Require at least two structurally distinct candidates before synthesis, even when the first looks sufficient. Whole-shape alternatives, not point fixes inside one shape.

Screen every candidate against the red flags below. Assume the next contributor is an agent that sees only the files it opened, copies the nearest example, and takes the shortest path that compiles. Prefer the design where a change that looks right from one file is right for the whole repo.

Compare viable candidates on interface depth. Prefer the design that hides more complexity behind a smaller, simpler public surface.

## Phase C. Agree (opt-in)

By default, proceed straight to implementation with the synthesized design. Pause for sign-off only when the user asks ("architect with checkpoint", "show me before implementing").

The synthesis can ship as its own commit (scaffold first). Planned, scoped breakage during fill-in is fine. For adversarial pressure before implementing, run **interrogate** on the sketch. If the user pushes back on the shape, treat it as Phase A evidence. Re-ground and re-run Phase B before writing more code.

## Phase D. Implement against the sketch

Replace `not implemented` bodies with code. The sketch is the contract. Deviations are signal to surface, not friction to absorb. If a function needs a parameter the sketch did not anticipate, ask whether the sketch was wrong, the requirement was missed, or the implementation is overreaching.

## Phase E. Scrap when the architecture is wrong

If implementation keeps producing friction the sketch cannot absorb, throw the sketch out. Do not bolt fixes onto a wrong design. The signal is a pattern:

- The same shape of workaround appears across unrelated code.
- Several unrelated edge cases each need special-case branches.
- Types need escape hatches (`any`, casts, optional fields that are always set in practice) to compile.
- The "we need a lock" reflex when the sketch said the state was not shared.
- Callers must know the abstraction's internal rules to use it.
- Two or more independent Phase D deviations of the same shape.

A few edge cases do not condemn an architecture. Complexity in the data is not complexity in the design. When you scrap: re-run **how** over what was built, redesign as if the new constraints were day-one assumptions, subtract before you add (the new sketch is smaller than the old one before it grows), and return to Phase B.

## Outputs

The caller's usage first, and the type sketch derived from it. One file of new types and signatures for small changes. A module map plus type definitions for larger work. A short rationale alongside: the usage sketch, the candidates, and the synthesis decision.

## Design red flags

- **Shallow module.** A large interface that hides little. Callers coordinate several methods for one operation, public options expose internal stages, or learning the interface does not save the caller from learning the implementation. A deep module is not a deep call chain.
- **Information leakage.** Several modules depend on the same internal decision, so a change needs coordinated edits. Re-exported transport or wire types are leakage. Parse external data into domain types behind the interface.
- **Temporal decomposition.** Modules organized by execution order (load, validate, transform, save) that repeat one representation and its invariants. Group by the knowledge a module owns.
- **Pass-through method.** Forwards the same arguments to another method of the same shape. Remove it, unless it adds policy, adaptation, or a distinct abstraction.
- **Split ownership.** More than one module writes the same state or keeps its own copy. Give each piece of state one owner.
- **Two ways to do one task.** An agent copies whichever it finds first. Keep one way. Move callers and delete the others in the same change.
- **Importable internals.** If outsiders can import internals, an agent will. Make an import from outside fail the build.
- **Hand-synced list.** Two places list the same items. Keep one list and derive the rest, or make the build fail when they disagree.
