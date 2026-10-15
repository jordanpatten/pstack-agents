#!/usr/bin/env bash
# Install pstack for Claude Code, Codex, and Grok Build (macOS, Linux, cloud sessions).
# Usage: install.sh [claude] [codex] [--uninstall]
#   No target names means both. Grok Build reads both locations, so it needs no target.
set -euo pipefail

src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
targets=()
uninstall=0
for arg in "$@"; do
	case "$arg" in
		claude|codex) targets+=("$arg") ;;
		--uninstall) uninstall=1 ;;
		*) printf 'unknown argument: %s\n' "$arg" >&2; exit 2 ;;
	esac
done
[ "${#targets[@]}" -eq 0 ] && targets=(claude codex)

begin='<!-- pstack:begin -->'
end='<!-- pstack:end -->'

skill_names() {
	for d in "$src"/skills/*/; do basename "$d"; done
}

remove_skills() {
	local dest="$1"
	for n in $(skill_names); do rm -rf "${dest:?}/$n"; done
}

copy_skills() {
	local dest="$1"
	mkdir -p "$dest"
	remove_skills "$dest"
	for n in $(skill_names); do cp -R "$src/skills/$n" "$dest/$n"; done
}

render_rules() {
	sed "s#{{PSTACK_SKILLS}}#$1#g" "$src/rules/pstack-core.md"
}

strip_block() {
	local file="$1"
	[ -f "$file" ] || return 0
	awk -v b="$begin" -v e="$end" '$0==b{skip=1;next} $0==e{skip=0;next} !skip' "$file" > "$file.tmp"
	mv "$file.tmp" "$file"
}

install_claude() {
	local home="$HOME/.claude"
	if [ "$uninstall" -eq 1 ]; then
		remove_skills "$home/skills"
		rm -f "$home/rules/pstack-core.md" "$home/agents/pstack-delegate.md" "$home/agents/pstack-comment-sicko.md"
		printf 'claude: removed\n'
		return
	fi
	copy_skills "$home/skills"
	mkdir -p "$home/rules" "$home/agents"
	render_rules "$home/skills" > "$home/rules/pstack-core.md"
	cp "$src/claude-agents/pstack-delegate.md" "$home/agents/pstack-delegate.md"
	cat "$src/claude-agents/pstack-comment-sicko.header.md" "$src/skills/pstack-no-comments/comment-sicko.md" > "$home/agents/pstack-comment-sicko.md"
	printf 'claude: skills in %s, rules in %s, agents in %s\n' "$home/skills" "$home/rules" "$home/agents"
}

install_codex() {
	local skills="$HOME/.agents/skills"
	local agents_md="${CODEX_HOME:-$HOME/.codex}/AGENTS.md"
	if [ "$uninstall" -eq 1 ]; then
		remove_skills "$skills"
		strip_block "$agents_md"
		printf 'codex: removed\n'
		return
	fi
	copy_skills "$skills"
	mkdir -p "$(dirname "$agents_md")"
	touch "$agents_md"
	strip_block "$agents_md"
	{
		printf '%s\n' "$begin"
		render_rules "$skills"
		printf '%s\n' "$end"
	} >> "$agents_md"
	printf 'codex: skills in %s, rules appended to %s\n' "$skills" "$agents_md"
}

for t in "${targets[@]}"; do
	case "$t" in
		claude) install_claude ;;
		codex) install_codex ;;
	esac
done
