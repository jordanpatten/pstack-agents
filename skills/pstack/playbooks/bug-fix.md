### Bug fix

**You own this task. Plan, review, verify.** Delegate investigation and the fix to subagents. Stay in the lead.

Be scientific. Every shipped line traces to runtime evidence. Belt-and-suspenders code that "might help" is a hypothesis, not a fix. It does not ship. When evidence refutes a hypothesis, revert what it motivated. The smallest change the evidence justifies ships, nothing more.

1. Reproduce it yourself on the matching surface (the project verify skill, a browser tool, Playwright, a tmux session for a CLI, curl for a service), even when a debug protocol says to ask the user to reproduce. Ask the user only with a stated, specific reason your tools cannot reach the target, and only after you drive it as far as it goes. If it will not reproduce directly, synthesize the trigger, tighten conditions, or instrument until it fires.
2. Binary-search the cause. Form the candidate hypotheses, then rule them out until one survives. Seed them with **how** over the affected subsystem and **why** for regression history. Each pass, take the split that cuts the most remaining problem space, get runtime evidence, and eliminate. When program state is unclear, add instrumentation or logging and read it as the code runs. Do not guess. For a long or stubborn hunt, drive it with `/goal` and a checkable condition. Confirm the surviving mechanism with runtime evidence before step 3.
3. Plan the fix. If it crosses a function boundary, run **architect** first. Delegate implementation to a delegate subagent on the code model (the hardest-changes model for a gnarly fix, see `../harness.md`) with a specific scope.
4. Verify on the same surface. The original repro now passes. "Inconclusive" or wrong-surface is not a pass. Flag it. Unit tests show branch behavior, not bug absence.
5. Stage the commits so the failing repro lands before the fix in git history. Use **tdd** for the failing-test-first cadence when the bug has a cheap local test path. Skip it when the test would be expensive, integration-heavy, or unclear. This is the canonical sequence-verifiable-units shape: the failing test first and the fix on top.
6. Run **Opening a PR** (`playbooks/opening-a-pr.md`).

**Reply:** what was broken, the root cause, the fix, and how you verified it. Paste the failing-then-passing repro output verbatim.
