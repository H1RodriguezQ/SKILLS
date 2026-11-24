# Activa o desactiva mods de Cities: Skylines II por su numero de Paradox Mods (sale entre parentesis en Logs\Modding.log).
# Uso: powershell -ExecutionPolicy Bypass -File mods.ps1 -Ids 80095,75250            -> desactiva
#      powershell -ExecutionPolicy Bypass -File mods.ps1 -Ids 80095,75250 -Activar   -> vuelve a activar
# shortcut: edita la copia local del playset y la marca como mas nueva que la nube; si aun asi se revierte, hacerlo desde el menu Playset.
param([Parameter(Mandatory)][string[]]$Ids, [switch]$Activar)
$ErrorActionPreference = 'Stop'
$Ids = $Ids -split ',' | ForEach-Object Trim   # con -File, "1,2" llega como un solo texto
$file = "$env:USERPROFILE\AppData\LocalLow\Colossal Order\Cities Skylines II\.cache\Mods\playset_config.json"
if (Get-Process Cities2 -ErrorAction SilentlyContinue) { throw "Cierra Cities: Skylines II primero." }

$txt = [IO.File]::ReadAllText($file)
$cfg = $txt | ConvertFrom-Json   # valida que el JSON este sano antes de tocarlo
$activo = $cfg.playsets | Where-Object id -eq $cfg.activePlaysetId
$m = [regex]::Match($txt, '\{"id":"' + [regex]::Escape($cfg.activePlaysetId) + '".*?"mods":\[[^\]]*\]')
if (-not $m.Success) { throw "No encuentro el playset activo en $file" }

Copy-Item $file "$file.bak-$(Get-Date -Format yyyyMMdd-HHmmss)"
$de, $a = if ($Activar) { 'false', 'true' } else { 'true', 'false' }
$bloque = $m.Value
foreach ($id in $Ids) {
    $antes = '"sourceId":"' + $id + '","isEnabled":' + $de
    if ($bloque.Contains($antes)) { $bloque = $bloque.Replace($antes, '"sourceId":"' + $id + '","isEnabled":' + $a); "OK   $id -> isEnabled=$a" }
    elseif ($bloque.Contains('"sourceId":"' + $id + '"')) { "Ya  $id estaba en isEnabled=$a" }
    else { Write-Warning "$id no esta en el playset activo ($($activo.presentation.name))" }
}
# Fecha de cambio = ahora: si no, el juego cree que la nube es mas nueva y revierte (playset_sync.json lastSyncedAt)
$ahora = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
$bloque = [regex]::Replace($bloque, '"modifiedAt":"[^"]*"', '"modifiedAt":"' + $ahora + '"', 1)
$txt = $txt.Remove($m.Index, $m.Length).Insert($m.Index, $bloque)
$null = $txt | ConvertFrom-Json   # comprobacion: sigue siendo JSON valido
[IO.File]::WriteAllText($file, $txt, (New-Object Text.UTF8Encoding $false))
