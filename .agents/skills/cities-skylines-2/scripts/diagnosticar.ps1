# Resume los errores de la ultima partida de Cities: Skylines II, agrupados por mod/asset culpable.
# Uso: powershell -ExecutionPolicy Bypass -File diagnosticar.ps1 [-Anterior]
param([switch]$Anterior)
$dir = "$env:USERPROFILE\AppData\LocalLow\Colossal Order\Cities Skylines II"
$log = if ($Anterior) { "$dir\Player-prev.log" } else { "$dir\Player.log" }
if (-not (Test-Path $log)) { throw "No encuentro $log" }
$l = Get-Content $log

$ver = ($l | Select-String 'Game version:' | Select-Object -First 1).Line
$mapa = (Select-String "$dir\Logs\SceneFlow.log" -Pattern "Starting game from '([^(]+)" -EA SilentlyContinue | Select-Object -Last 1).Matches.Groups[1].Value
$mods = (Select-String "$dir\Logs\Modding.log" -Pattern '^\s+- .* v[\d\.]+ \(\d+\)' -EA SilentlyContinue | Select-Object -Expand Line -Unique).Count
"== $ver | Mapa: $(if ($mapa.Trim(" '")) { $mapa.Trim(" '") } else { '?' }) | Mods cargados: $mods"
# Mods que piden otra version del juego = el juego esta desactualizado (causa de muchos errores en cadena)
$l | Select-String 'Supported version is ([\d\.]+f\d)' | Select-Object -First 1 | ForEach-Object {
    "!! Hay mods hechos para la version $($_.Matches.Groups[1].Value). Actualiza el juego primero." }

$res = for ($i = 0; $i -lt $l.Count; $i++) {
    if ($l[$i] -notmatch '\[(CRITICAL|ERROR)\]') { continue }
    $nivel = $Matches[1]
    $bloque = ($l[$i..([Math]::Min($i + 15, $l.Count - 1))]) -join "`n"
    # Culpable: asset roto, o el primer namespace de la traza que no es del juego/Unity/.NET
    if ($l[$i] -match 'initializing prefab: ([^(]+)') { $culpable = "Asset: $($Matches[1].Trim())" }
    elseif ($bloque -match '(?m)^\s+at (?!Game\.|Unity|System\.|Colossal\.|Mono\.)([A-Za-z_][\w]*)\.') { $culpable = "Mod: $($Matches[1])" }
    elseif ($l[$i] -match '^\[([^\]]+)\] \[') { $culpable = "Mod: $($Matches[1])" }
    else { $culpable = 'Desconocido' }
    $msg = ($l[$i] -replace '^.*?\[(CRITICAL|ERROR)\]\s*', '')
    [pscustomobject]@{ Nivel = $nivel; Culpable = $culpable; Mensaje = $msg.Substring(0, [Math]::Min(150, $msg.Length)) }
}

if (-not $res) { "Sin errores. La partida cargo limpia."; return }
$res | Group-Object Nivel, Culpable | Sort-Object @{ e = { $_.Group[0].Nivel -eq 'CRITICAL' }; Descending = $true }, @{ e = 'Count'; Descending = $true } |
    ForEach-Object { [pscustomobject]@{ Nivel = $_.Group[0].Nivel; Veces = $_.Count; Culpable = $_.Group[0].Culpable; Ejemplo = $_.Group[0].Mensaje } } |
    Format-Table -AutoSize -Wrap | Out-String -Width 220
"CRITICAL = rompe la partida (desactivar ese mod).  ERROR de Asset = ese edificio no aparece, no es grave."
