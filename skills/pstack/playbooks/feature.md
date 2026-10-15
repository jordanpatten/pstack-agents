### Feature

**You own the design. Plan, review, verify.** Delegate implementation. Stay in the lead.

1. Run **how** over the affected subsystem.
2. Run **architect** for parallel design exploration.
3. Write the throughput checkpoint as four todo items. A dimension that does not apply (a single file, no fan-out) keeps its item with `n/a: <reason>` rather than being dropped.
   - **Blocking first steps.** Gates that run before fan-out.
   - **Independent workstreams.** Disjoint files, services, or layers parallelize. Shared writes serialize.
   - **Shared mutable state.** Default to splitting the target (separate-before-serializing-shared-state). Serialize only for real invariants.
   - **Smallest safe decomposition.** If one worker is best, say why.
4. Delegate code-writing to a delegate subagent on the code model (the hardest-changes model for the hardest changes, see `../harness.md`) with a specific scope: file paths, the named data shape and its organizing structure (a state machine over scattered booleans, a table or registry over branching, a typed model over repeated shape assumptions) chosen before the delegate writes logic, and success criteria. When the implementation admits multiple valid shapes (error handling, abstraction layer, test structure), delegate through **arena** instead, so the runners surface the alternatives and the cross-judge guards the pick. This step is mandatory, with no skip-with-reason escape. The laziness protocol does not override it, because the gain is review separation, not lines saved. A subagent that cannot spawn satisfies it by owning the diff directly with the same review separation. Surgical edits. Port shared-primitive improvements to every consumer and verify each. Commit liberally.
5. Verify on the matching surface. "Inconclusive" or wrong-surface is not a pass. Flag it.
6. Rebase into small, ordered commits, building, verifying, and committing each unit before the next (sequence-verifiable-units). Stack follow-ups.
7. If the design is contested, run **interrogate** before shipping.
8. Run **Opening a PR**.

Code-coupled work (one feature, one migration) goes to a single owner with the checkpoint inline. That owner fans out internally after the blocking phase. Parent-level fan-out is for slices that produce independent artifacts (audits, cross-subsystem investigations, competing experiments). Rewrite the checkpoint at phase boundaries. Spawn a fresh owner rather than chaining resumes.

**Reply:** what you built, what you chose and why, the throughput checkpoint, and open decisions. Use tables for design alternatives.
