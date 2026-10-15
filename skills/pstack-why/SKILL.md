---
name: pstack-why
description: Investigate why code was built the way it is, using git history, PRs, and every connected evidence source (issue tracker, docs, chat, observability, error tracking, analytics). Separates what the record states from what is inferred. Use how for mechanics.
disable-model-invocation: true
---

# Why

Investigate the motivation behind code. **how** answers what the code does. **why** answers what forces led to its shape.

Operate as a careful, precise investigator. Be honest about what you know against what you infer.

## 1. Understand the target and the question

The target is usually a chunk of code, a pattern, a feature, or a named design decision. The question is usually a design rationale, a trade-off, a motivating edge case, an external constraint, dead code, or a history sweep. If the target is vague, make your best guess from context (open files, recent edits, what was just discussed), state it in one line so the user can redirect, and proceed.

## 2. Build the code anchor

Before you spawn investigators, build the seed context yourself: file paths and line ranges, key symbols, the last commits that touched the target, PR numbers from merge commits, and linked ticket IDs. Useful commands:

- `git blame -L <start>,<end> <file>` for last-touch commits.
- `git log --follow -p -- <file>` for full history through renames.
- `git log --oneline -20 -- <file>` for recent commits with PR numbers.
- `gh pr view <number> --json title,body,author,createdAt,mergedAt,labels,closingIssuesReferences,comments,reviews` for PR bodies and discussion.

This anchor goes to every investigator and to the synthesizer.

## 3. Spawn parallel investigators

Default to the full parallel investigation. The goal is a complete coverage map. Document the null result. Do not skip the search.

List the MCP servers connected in this session and map each to one evidence category:

1. Source control history (always available through git and `gh`). Best at implementation-time rationale captured during review.
2. Issue or ticket tracker. Best at the product or business forcing function.
3. Long-form documents. Best at design rationale written before it became code.
4. Real-time team chat. Best at deliberation that never reached a doc.
5. Infrastructure observability. Best at the runtime reality that motivated the code (timeouts, retries, rate limits).
6. Error and exception tracking. Best at the errors that motivated defensive code.
7. Product analytics warehouse. Best at flag-gated code, experiments, data migrations, and "where did this number come from".

Spawn one investigator per category that has a matching source, all in one message, each owning exactly one source. Investigators run on the worker model and must not write anything. Use a full-capability subagent, not a read-only one, when the investigator needs MCP tools. Build each prompt from `investigator-prompt.md` in this directory, with the code anchor, the user's question, and its one source filled in.

Skip a category only with a written reason that goes into Sources Consulted. Two reasons are valid. No source for that category is connected (a gap, not a choice), or the category is provably irrelevant, not just probably irrelevant.

## 4. Synthesize

Spawn one synthesizer on the judgment model with `synthesizer-prompt.md` from this directory, filled with the investigator findings (including nulls and skips), the code anchor, and the user's question. It follows the confidence framework below and writes these sections: The Question, The Code in Question, What We Found, What We Can Reasonably Infer, Competing Hypotheses, What We Don't Know, Sources Consulted (one line per category, including empty and skipped ones with the reason), and Confidence Summary. If the question precedes a change to this code, it ends with a Preserve, Change, Avoid, and Risk constraint set.

## 5. Present

Present the synthesizer's output. Light edits for clarity are fine. Do not rewrite the confidence language.

## Confidence framework

Every claim sits in one tier, and the tier sets its section and phrasing.

1. **Direct.** An author wrote the reason down: a PR description, a ticket, a code comment, a design doc, a chat message. Phrase it confidently and cite it. "This exists because X."
2. **Supported.** Several indirect pieces converge. Phrase it as derived and cite each piece. "The evidence points strongly to X: A, B, and C."
3. **Inferred.** A reasonable reading that nothing states. Make the chain explicit. "Given A and B, C seems likely because D."
4. **Speculative.** Plausible on thin evidence, with other explanations fitting as well. "One possibility is X, but we have no direct evidence." Usually in Competing Hypotheses.
5. **Unknown.** You looked and could not find out. Say exactly what you searched. "We searched the tracker for A and B, scanned the 6 PRs that touched this file since 2023, and grepped for the literal. None gave a rationale."

Rules:

- Confidence words ("because", "the reason is", "was designed to", "fixes", "the team decided") need a citation next to them. Never use them for inferences.
- Hedges ("appears to", "likely", "suggests", "is consistent with") mark interpretation. Use them in the inference section.
- Avoid "obviously", "clearly", "of course", "just", and "I think".
- Do not rationalize. Code that makes sense today may have been written for reasons that no longer apply. Do not assume a consistent pattern was intentional when it may be copy-paste. Absence of evidence is not evidence of absence.
- When the user embeds a hypothesis ("I assume it's for performance?"), treat it as one candidate and check it independently. Do not confirm it by default.
- When sources contradict, show both with citations. Do not pick the tidier story.
- Code is not evidence for its own intent.
- An output with no "What We Don't Know" section is suspicious.
- Avoid recency bias. The current shape is often an accretion of many decisions. Trace back.
