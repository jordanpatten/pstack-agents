---
name: pstack-interrogate
description: Multi-model adversarial review of a diff or files. Several reviewers on different models try to break the change, then a lead judge sorts findings into act on, consider, noted, and dismissed. Use for "interrogate", "adversarial review", "challenge this", "stress test this code", or "tear this apart".
disable-model-invocation: true
---

# Interrogate

Spawn one reviewer per model to review code changes adversarially. The adversarial signal comes from model diversity, not assigned personas. The deliverable is a synthesized verdict. Do NOT auto-apply changes.

## Step 1. Scope

- If the user points at specific files or a diff, use that.
- On a feature branch, run `git diff main...HEAD` (or the right base branch) for the full changeset.
- If the user refers to recent work, gather the relevant files.

Package the diff or file contents with any surrounding context files the reviewers need.

## Step 2. Intent

Before you spawn reviewers, state the intent in one clear paragraph, from the user's message, commit messages, the PR description, and the code. If you are unsure about the intent, ask the user before you proceed.

## Step 3. Spawn reviewers

Launch all reviewers in one message, as read-only subagents, one per panel model in `../pstack/harness.md`, labeled Reviewer A, B, and so on.

Fill `reviewer-prompt.md` from this directory the same way for every reviewer, with the stated intent, the diff or file contents, the rubric from `rubric.md`, and the code-quality lens from `code-quality-review.md`.

The panel must use at least two different models. If your tool offers only one model, run it at two effort levels and say in the verdict that the panel had low diversity.

## Step 4. Synthesize

Parse every reviewer's findings. Merge findings that describe the same issue differently, and note which models raised each one. Findings that two or more models raised independently are the highest signal. Read a lone model's finding, but weight it accordingly. Note disagreements. If one model flags something and another explicitly says the opposite, that is context for the verdict.

## Step 5. Lead judgment

You are the lead reviewer, a pragmatic senior engineer, not a neutral aggregator. Read `lead-judgment.md` for the full framework. Put every finding in one of four buckets, with the models that raised it and a one-line rationale.

- **Act on.** Real issues affecting correctness, security, or maintainability given the actual goals. They would block a real PR.
- **Consider.** Legitimate, but you are not sure they outweigh the cost of addressing them now. Worth the user's attention.
- **Noted.** Technically valid but not actionable: context-dependent, premature optimization, or low-impact at this stage.
- **Dismissed.** Wrong, nitpicky, or missing context, with a brief reason.

## Output format

### Intent
> The intent paragraph from Step 2.

### Reviewers
- Reviewer [label]: [model], [N findings]

### Act On
Each with its description, which models raised it, and why it matters.

### Consider
Each with its description, which models raised it, and the trade-off.

### Noted
A brief list.

### Dismissed
Each with a brief reason.

### Agreement Map
Where the models agreed and diverged, and what that pattern says.
