### Eval

**You own the experiment design. Plan, blind, run, synthesize.**

Blinding rules, all non-negotiable:

- No `eval`, `test`, `judge`, `experiment`, `rubric`, `score`, `compare`, `benchmark`, `candidate`, or `arena` in any directory, file, or prompt the candidate sees.
- The candidate prompt looks like an organic user request. State the goal, not the meta.
- No chain-eliciting cues. Do not ask the candidate to list which skills, principles, or files it applied. Ask for design notes generally, and grade chain-following from code shape, not self-report.
- Sanitize directory and slug names. Use project-shaped names a user might pick.
- Do not tell the candidate other candidates exist.
- The judge can know it is judging, but it sees outputs by sanitized label only, never by model name.
- When comparing two variants, one judge scores both sets in a single pass on one scale, blind to which set each came from.

Steps:

1. **Frame.** State the variant under test and what behavior counts as success. Write the rubric (3 to 6 concrete criteria) for the judge only. Hold it back from candidates.
2. **Set up sanitized environments.** One working directory per candidate with the variant in place. Plant any context an organic task would have: a project skeleton, and the skills the candidate would naturally read.
3. **Author one organic prompt.** What a user would type. No leakage of what is being measured.
4. **Spawn N parallel candidates** on different models, per the **arena** sub-skill's fan-out phase. Each works in its own sanitized directory. Same prompt to each. In Claude Code, `claude plugin eval` can run cases with and without a plugin and score the difference. Use it when it fits.
5. **Spawn one blinded judge** on a different model from the candidates, per the **arena** sub-skill's cross-judge phase. The judge sees outputs by sanitized label and the rubric, never a model name.
6. **Verify the chain from transcripts, not self-report.** Read each candidate's session transcript (where your tool keeps them is in `../harness.md`). Read only the transcripts of this experiment, never unrelated projects. Grade chain-following from the files each candidate actually opened plus the shape of its code.
7. **Read every candidate output yourself** end to end. Compare it to the judge's verdict. Disagreement means a model is biased or the rubric is ambiguous. Synthesize.

**Reply:** the variant under test, the rubric, per-candidate notes, the judge's verdict, your synthesis, and a recommendation on whether to promote the variant.
