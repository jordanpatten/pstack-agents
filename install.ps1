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

function Get-Rules([string]$skillsDir) {
	$fwd = $skillsDir -replace '\\', '/'
	(Get-Content -Raw (Join-Path $src 'rules\pstack-core.md')).Replace('{{PSTACK_SKILLS}}', $fwd)
}

function Remove-Block([string]$file) {
	if (-not (Test-Path $file)) { return }
	$out = New-Object System.Collections.Generic.List[string]
	$skip = $false
	foreach ($line in Get-Content $file) {
		if ($line -eq $begin) { $skip = $true; continue }
		if ($line -eq $end) { $skip = $false; continue }
		if (-not $skip) { $out.Add($line) }
	}
	Set-Content -Path $file -Value $out -Encoding utf8
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
		$sicko = (Get-Content -Raw (Join-Path $src 'claude-agents\pstack-comment-sicko.header.md')) + (Get-Content -Raw (Join-Path $src 'skills\pstack-no-comments\comment-sicko.md'))
		[IO.File]::WriteAllText((Join-Path $agents 'pstack-comment-sicko.md'), $sicko, $utf8)
		Write-Host "claude: skills in $skills, rules in $rules, agents in $agents"
	}
	if ($t -eq 'codex') {
		$skills = Join-Path $HOME '.agents\skills'
		$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME '.codex' }
		$agentsMd = Join-Path $codexHome 'AGENTS.md'
		if ($Uninstall) {
			Remove-Skills $skills
			Remove-Block $agentsMd
			Write-Host 'codex: removed'
			continue
		}
		Copy-Skills $skills
		New-Item -ItemType Directory -Force $codexHome | Out-Null
		if (-not (Test-Path $agentsMd)) { New-Item -ItemType File $agentsMd | Out-Null }
		Remove-Block $agentsMd
		$existing = if ((Get-Item $agentsMd).Length -gt 0) { (Get-Content -Raw $agentsMd).TrimEnd() + "`n" } else { '' }
		$block = "$begin`n" + (Get-Rules $skills).TrimEnd() + "`n$end`n"
		[IO.File]::WriteAllText($agentsMd, $existing + $block, $utf8)
		Write-Host "codex: skills in $skills, rules appended to $agentsMd"
	}
}
