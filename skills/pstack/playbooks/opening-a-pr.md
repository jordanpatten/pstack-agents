### Opening a PR

Run at the end of every other playbook that changes code.

**Worktree.** Work from a git worktree or a branch off main. Parallel subagents on the same branch each get their own worktree, or run `git fetch && git reset --hard origin/<branch>` between them. Dirty branch with unrelated work: save a patch, start a fresh worktree, apply. Snarled worktree: reset from main and redo minimally.

**Commits.** Commit liberally. Rebase into small, ordered commits before you open PRs. Each commit is a future PR: landable on its own, ordered to tell the story. Amend when the fix belongs in a just-made commit. Make a new commit when it is separable. Commit bodies do not restate the subject.

**Before review.** Do a slop pass over the diff before you commit. (The Cursor original calls `/deslop` from a separate plugin that pstack does not include. In its place, reread the diff against the principles and remove what fails them: dead code, guards for states that should never exist, casts, one-caller wrappers, and speculative abstractions.) Run **no-comments** before review. Write every PR title, description, and commit body with **technical-writing** (every layer except Diátaxis, plus the STE vocabulary rules: one word per action, keep articles, a plain verb over an "-ing" form where one works), then apply **unslop**.

**Titles.** Conventional Commits `type(scope): subject`, no trailing period. The type is one of `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, or `perf`. The scope is the area. The subject is short and imperative, and names a real symbol when one carries the change, for example `fix(auth): retry token refresh once on 401`.

**Descriptions.** The PR body is a one-minute briefing for a reviewer who has the diff, not a lab notebook. It says why the change exists, what it leaves out, what it could break, and how you proved it works. Short, simple sentences with few identifiers. The body becomes the squash commit body, so keep it under about 40 lines. Use `##` headings, not bold lead-ins, in this order, and drop a section with nothing to say:

- `## Why`. The problem and approach, 1 to 3 short sentences. No SHAs, rebase history, or "based on main" preamble.
- `## What changed`. 1 to 3 short bullets. Name a real symbol or path only when it carries the change. Name both sides of a rename.
- `## Scope`. Always present. 1 to 3 short items on what it covers and what it deliberately leaves out (a follow-up, a known gap). No file-by-file essay.
- `## Tradeoffs`. Only rejected alternatives a reviewer would otherwise ask about.
- `## Blast Radius`. 1 to 2 sentences on who or what it touches and why that is safe or risky. If main is red, state the cost of leaving it red.
- `## Verification`. 1 to 3 bullets, each a real run and its outcome. For perf, one primary number with its unit, `before → after`, and a link to the rest. No methodology essays or metric tables.

After the sections, attach screenshots or videos when they prove a claim. Full SHAs, review-panel transcripts, and file-by-file checklists go in a linked artifact, not the body.

**Forge.** Use the GitHub CLI (`gh`) for create, edit, view, checks, and merge. Where `gh pr` is blocked (Claude Code cloud sessions, see `../harness.md`), use the session's built-in pull request tools or `gh api` REST calls for the same operations.

**Size and stacks.** Prefer five narrow PRs to one large PR. A stack is a base-branch chain. The root PR targets trunk. Each child branch rebases onto its parent's exact tip, and its PR targets the parent branch (`gh pr create --base <parent-branch>`, retarget with `gh pr edit <pr> --base <parent-branch>`). When a parent merges, move its child onto trunk per the Shipping playbook. Branch from trunk only for independent work. Rebase on trunk before substantial stack work.

**Readiness.** Open every PR ready, never as a draft (`gh pr create` without `--draft`). If one opens as a draft, run `gh pr ready <number>`. Run `gh pr view <number>` before you refer to PR status.

**Babysit.** Opening a PR does not start a babysit. Post the URL and keep building. Finish the phase or stack first. Run a babysit pass only when the user asks for one after the whole stack exists. Push back when feedback drifts from intent.

A subagent that opens a PR runs **interrogate**, the slop pass, and **no-comments**, posts the URL, and returns to the parent without babysitting.
