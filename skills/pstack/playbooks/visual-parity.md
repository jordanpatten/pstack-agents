### Visual parity

**You own pixel-exact equivalence. The baseline is the spec. You do not touch it.** Verify equivalence by image diff, not by eye.

1. Establish the baseline first, before any migration: a visual regression harness that screenshots the current component across its states, plus the target when you match two implementations. No baseline, no parity claim. This is a blocking prerequisite, not a follow-up.
2. State and hold the anti-shortcut rules: no harness modifications, no baseline tampering, no component restructuring to make a diff pass. If the baseline looks wrong, stop and ask. Do not edit it.
3. Migrate one component at a time. Parallelize across worktrees, one owner per component. Shared primitives migrate first as a blocking phase.
4. Verify each component against its baseline by image diff on the real surface. A nonzero diff is a fail. Investigate the pixel delta. Loop per component until the diff is zero (`/goal` works well here).
5. Run **Opening a PR** per component or per safe batch.

**Reply:** the components migrated, the diff result for each, the baseline harness location, and what is left.
