### Autonomous run

**You own the exit condition. Define done, then drive to it without stopping.**

1. State the exit condition as a checkable predicate before the first iteration: tests green, repro fixed, all N PRs merged, pixel diff zero.
2. Pick the wake mechanism. For "keep working until X", use `/goal <condition>`, which re-evaluates after every turn. Write the condition so your own output can demonstrate it (for example "`npm test` exits 0"), because the evaluator only reads the conversation. For an event to watch (CI, a merge, a branch advancing), use `/loop` with a dynamic interval, or a background watcher (`gh pr checks --watch`, a Monitor script) with a long heartbeat as fallback. With no event, use a fixed interval sized to when the result is worth re-checking.
3. Each iteration makes the smallest change the evidence justifies, verifies it against the predicate, commits if it advanced, and discards changes that did not help. Belt-and-suspenders code that "might help" gets reverted, not left in. Verify each unit before the next instead of batching checks at the end.
4. Mid-run discoveries are yours. Fix broken skills, related bugs, flaky verifiers, review noise, tooling failures, orphaned follow-ups, and fixable drift yourself. Put out-of-band fixes in their own commit or PR. Do not park reversible work for the human, and do not ask questions. Surface only irreversible actions, product or preference calls that no experiment can settle, or a real dead end. Keep the predicate as the main drive, and return to it after each side fix.
5. Checkpoint every iteration with **show-me-your-work**: one row for what changed and whether the predicate moved.
6. Stop when the predicate is met. A plateau is not a stop. Keep going and pivot your approach to push past it. Surface a real dead end rather than spinning, and never relax the predicate to declare victory.

**Reply:** the exit condition, iterations run, what landed, what was discarded, and the final predicate state.
