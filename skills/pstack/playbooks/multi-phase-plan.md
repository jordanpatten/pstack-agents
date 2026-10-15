### Multi-phase or multi-PR plan

**You own the plan, not the code. The plan is a checklist an owner runs box by box and the user audits from the evidence.** The plan is the deliverable. Do not implement.

1. When the change is one or two files with an obvious approach, skip the plan. Say so and stop.
2. Settle open questions by prototype before you write. Run the Prototype playbook for each. Keep the branch, the SHA, and the screenshots for Appendix A. Ask the user only about a product or preference call that no run can settle, and give options.
3. Explore in delegate or read-only subagents to protect the context window. Each returns file pointers, conventions, test commands, and entry points. No inlined dumps.
4. Copy the skeleton below into the plan file and fill every placeholder. Unless the user names a path, write it under the repo's `docs/` or a scratch folder. Keep every heading in the order shown. One section per PR. One PR is one change with its own evidence.
5. Write it under **technical-writing** in full, then **unslop**. The body is one Diátaxis mode, how-to. Appendices hold explanation and reference. Each heading states the task or the finding. No long dashes. No mid-sentence colons.
6. Check the plan mechanically: every placeholder filled, every PR section has Files, Build, You see, the three Verify blocks, Review gate, and Merge, and every box names its evidence. If you will run this check often, script it (encode-lessons-in-structure).
7. Hand back. Post the plan path and the check output, then stop. Execution starts on the user's explicit go.

**Verification rule.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked. Every verification block opens with that sentence. The live block is mandatory. Live lanes drive the real surface at the PR head, each a separate verifier subagent with a concrete scenario, the screenshot or output it saves, and its pass predicate. Upstream pstack runs ten lanes on cloud machines. Run as many distinct scenarios as the change warrants, and always include the regression lane. The regression lane runs the same load-bearing scenario on trunk and on the head. If trunk does not have the feature, the lane records that fact and gates the behavior the diff adds plus the end state the user waits for, instead of inventing a trunk result. The perf gate is two-sided. Trunk and head must both produce the named metric. If trunk lacks the feature, isolate the work the diff adds and set an absolute budget for it plus the end-to-end state the user waits for. Never claim a ratio between unlike scenarios. A PR that changes an interaction is review-gated: the user reviews it with screenshots and a short video before merge. A PR that changes no interaction writes `**Review gate.** None. <PR id> is not review-gated.`

````markdown
# <Program> plan

<Under ten lines. What changes, for whom, the rule the program enforces, and the PR ids in order.>

## How to read this

One box is one unit of work. Every box names the evidence that checks it. A nested box is a sub-step of the box above it. Check a box only when its evidence exists: a file, a log line, a screenshot, a test run, or a SHA. The body is a how-to. The appendices explain and record.

Execution follows `<playbook name>`. <Who merges, and which PRs stop at merge-ready for the user.>

Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

## Program checklist

- [ ] State the protocol and this plan to the user, then stop. Start only on the user's explicit go.
- [ ] Follow this dependency graph.
  - [ ] <PR id> and <PR id> are independent and first. Both branch from `main`.
  - [ ] <PR id> after <PR id>.
- [ ] Hold the file boundaries. <PR id> touches only `<glob>`.
- [ ] For every PR: run lint and typecheck before the push, open it ready per Opening a PR, triage every bot comment per the Babysit rubric, and rebase onto current trunk before the verdict.
- [ ] For every PR: an independent verifier that did not write the code runs the live lanes at the head. Clean only when every lane is `PASS`. A new head gets a fresh verdict, except results that survive the patch-id rule in the Shipping playbook.

## <Task as a verb phrase> (<PR id>)

**Depends on.** <PR id, or None.>

**Files.**

- [ ] Edit `<path>`.
- [ ] Create `<path>`.
- [ ] Delete `<path>`.

**Build.**

- [ ] <One change. Name the symbol and the file.>

**You see.**

- [ ] <One observable result, with the exact log line or screen state.>

**Verify, unit.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

- [ ] <Test file and the case it gains.> Run `<command>`.

**Verify, live.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

- [ ] Lane 1. Regression lane against trunk. Run <the load-bearing scenario> at trunk and head. Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 2. <Scenario.> Save `<slug>.png`. Pass when <predicate>.

**Verify, perf.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

- [ ] Metric. <What is measured at both trunk and head.>
- [ ] Probe. <The command, run at trunk and at head, interleaved.>
- [ ] Baseline. Record the trunk <value> first.
- [ ] Rule. <Head against trunk, with the number that fails.>

**Review gate.** <The user reviews before merge: screenshots and a 30 to 60 second video. Or "None. <PR id> is not review-gated.">

**Merge.**

- [ ] A clean independent verdict at the exact head SHA.
- [ ] Bot triage done.
- [ ] Rebased onto current trunk after the verdict, patch-id unchanged.

## Close the program

- [ ] Every box above is checked with its evidence.
- [ ] Reply to the user with the report the execution playbook names.

## Appendix A. Prototype evidence

<Each open question a prototype answered, with the branch, SHA, and artifacts. Each question that stays unproven.>

## Appendix B. Alternatives rejected

<Each approach weighed and why it lost.>

## Appendix C. Risks

<Each risk with the PR it lands in and what the owner watches. A surface with no way to drive it live is a risk.>

## Appendix D. Links and reading list

<Docs to read before editing. Which PRs get how and interrogate. The decision-trail path.>
````

**Reply:** the plan path, the PR ids with their dependencies and the review-gated set, what the prototypes proved and what stays unproven, and the check output.
