### Session pickup

**You own the resume point. Read the prior trail. Do not redo it.**

1. Locate the prior trail: a session transcript (location per `../harness.md`; read only this project's transcripts), a resume note, a decision log, or a pushed branch. Read the last messages first, then scan back for the decision points. Parse a long transcript in a subagent and keep the reduced timeline in the main thread.
2. Reconstruct operational state: the branch and worktree, what already landed (`git log`, `git diff` against the base), the open todos, and the decisions made. The prior trail is authoritative input. Resist the urge to re-derive it.
3. Diff done against pending. Compare what shipped against what was planned, name the resume point, and do not re-run the prior repro or redo completed work. A "let me verify from scratch" pass treats an authoritative trail as untrustworthy.
4. Route the remaining work to the matching playbook and pick the verdict: continue the execution, ship a finished recommendation, ratify or override a prior conclusion, or write a postmortem of a failed run. This playbook ends here. The routed playbook owns the rest.
5. Verify the inherited claims against the original goal on the real artifact. A passing prior self-report is not proof.

**Reply:** where the prior agent stopped, what you inherited against what you redid (ideally nothing), the resume point, and the outcome.
