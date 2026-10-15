### Authoring or modifying a skill

**You own the skill's voice.**

1. Write the SKILL.md with YAML frontmatter (`name`, a `description` that says what it does and when to use it, and `disable-model-invocation: true` for workflows that should run only on request). Keep SKILL.md under about 500 lines and move detail into supporting files the SKILL.md links.
2. Validate the skill. The frontmatter has `name` and `description`, referenced files exist, and cross-skill links resolve. In Claude Code, `claude plugin validate <dir>` also checks plugin and skill frontmatter.
3. Write test cases if the skill is structural. Skip them if it is subjective.
4. Run **Opening a PR**.

When in doubt, delete. Keep only prose that changes a decision. Tell the agent to do the thing and skip the reason. Explain only when the rule is confusing without one. Match tone to scope. Point at structural sources (types, READMEs, config) instead of restating them (encode-lessons-in-structure). Delegate to other skills by path. Do not restate them. A workflow you keep hitting that is not captured is a reason to propose a new skill.

**Reply:** a summary of the skill, the key design decisions, and validation notes.
