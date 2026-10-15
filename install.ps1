# Install pstack for Claude Code, Codex, and Grok Build on Windows.
# Usage: .\install.ps1 [-Targets claude,codex] [-Uninstall]
#   Grok Build reads both locations, so it needs no target of its own.
param(
	[ValidateSet('claude', 'codex')]
	[string[]]$Targets = @('claude', 'codex'),
	[switch]$Uninstall
)
$ErrorActionPreference = 'Stop'

$src = $PSScriptRoot
$begin = '<!-- pstack:begin -->'
$end = '<!-- pstack:end -->'
$skillNames = Get-ChildItem -Directory (Join-Path $src 'skills') | ForEach-Object Name

function Remove-Skills([string]$dest) {
	foreach ($n in $skillNames) {
		$p = Join-Path $dest $n
		if (Test-Path $p) { Remove-Item -Recurse -Force $p }
	}
}

function Copy-Skills([string]$dest) {
	New-Item -ItemType Directory -Force $dest | Out-Null
	Remove-Skills $dest
	foreach ($n in $skillNames) { Copy-Item -Recurse (Join-Path $src "skills\$n") (Join-Path $dest $n) }
}

function Read-Text([string]$path) {
	if (-not (Test-Path $path)) { return '' }
	[IO.File]::ReadAllText($path)
}

function Get-Rules([string]$skillsDir) {
	$fwd = $skillsDir -replace '\\', '/'
	(Read-Text (Join-Path $src 'rules\pstack-core.md')).Replace('{{PSTACK_SKILLS}}', $fwd)
}

function Remove-Block([string]$text) {
	$pattern = '(?s)\r?\n?' + [regex]::Escape($begin) + '.*?' + [regex]::Escape($end) + '\r?\n?'
	[regex]::Replace($text, $pattern, "`n").Trim([char]0xFEFF, "`r", "`n", ' ')
}

$utf8 = New-Object System.Text.UTF8Encoding($false)

foreach ($t in $Targets) {
	if ($t -eq 'claude') {
		$home_ = Join-Path $HOME '.claude'
		$skills = Join-Path $home_ 'skills'
		$rules = Join-Path $home_ 'rules'
		$agents = Join-Path $home_ 'agents'
		if ($Uninstall) {
			Remove-Skills $skills
			foreach ($f in @((Join-Path $rules 'pstack-core.md'), (Join-Path $agents 'pstack-delegate.md'), (Join-Path $agents 'pstack-comment-sicko.md'))) {
				if (Test-Path $f) { Remove-Item -Force $f }
			}
			Write-Host 'claude: removed'
			continue
		}
		Copy-Skills $skills
		New-Item -ItemType Directory -Force $rules, $agents | Out-Null
		[IO.File]::WriteAllText((Join-Path $rules 'pstack-core.md'), (Get-Rules $skills), $utf8)
		Copy-Item -Force (Join-Path $src 'claude-agents\pstack-delegate.md') (Join-Path $agents 'pstack-delegate.md')
		$sicko = (Read-Text (Join-Path $src 'claude-agents\pstack-comment-sicko.header.md')) + (Read-Text (Join-Path $src 'skills\pstack-no-comments\comment-sicko.md'))
		[IO.File]::WriteAllText((Join-Path $agents 'pstack-comment-sicko.md'), $sicko, $utf8)
		Write-Host "claude: skills in $skills, rules in $rules, agents in $agents"
	}
	if ($t -eq 'codex') {
		$skills = Join-Path $HOME '.agents\skills'
		$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME '.codex' }
		$agentsMd = Join-Path $codexHome 'AGENTS.md'
		if ($Uninstall) {
			Remove-Skills $skills
			if (Test-Path $agentsMd) {
				$rest = Remove-Block (Read-Text $agentsMd)
				[IO.File]::WriteAllText($agentsMd, $(if ($rest) { "$rest`n" } else { '' }), $utf8)
			}
			Write-Host 'codex: removed'
			continue
		}
		Copy-Skills $skills
		New-Item -ItemType Directory -Force $codexHome | Out-Null
		$rest = Remove-Block (Read-Text $agentsMd)
		$block = "$begin`n" + (Get-Rules $skills).TrimEnd() + "`n$end`n"
		$out = if ($rest) { "$rest`n`n$block" } else { $block }
		[IO.File]::WriteAllText($agentsMd, $out, $utf8)
		Write-Host "codex: skills in $skills, rules appended to $agentsMd"
	}
}
