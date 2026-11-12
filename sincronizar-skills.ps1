# Sincroniza las skills del cerebro:
#   .claude/skills  ->  .agents/skills  (otros agentes)
#   .claude/skills  ->  %USERPROFILE%\.claude\skills  (todos los proyectos)
# Uso: powershell -ExecutionPolicy Bypass -File sincronizar-skills.ps1
# Solo copia las skills de este repo; no toca otras skills de la carpeta global.

$ErrorActionPreference = "Stop"
$repo    = $PSScriptRoot
$origen  = Join-Path $repo ".claude\skills"
$agents  = Join-Path $repo ".agents\skills"
$global  = Join-Path $env:USERPROFILE ".claude\skills"

New-Item -ItemType Directory -Force -Path $agents, $global | Out-Null

Get-ChildItem -Directory $origen | ForEach-Object {
    foreach ($destino in @($agents, $global)) {
        $d = Join-Path $destino $_.Name
        if (Test-Path $d) { Remove-Item -Recurse -Force $d }
        Copy-Item -Recurse $_.FullName $d
    }
    Write-Host "OK  $($_.Name)"
}
Write-Host "`nListo. Abre una sesion nueva de Claude Code para ver los cambios."
