# Deja Cities: Skylines II en graficos rapidos para el PC de Henry
# (Ryzen 7 7735HS + Radeon 680M integrada, 4 GB de video compartido, 20 GB RAM).
# Uso:  powershell -ExecutionPolicy Bypass -File optimizar.ps1            -> aplica
#       powershell -ExecutionPolicy Bypass -File optimizar.ps1 -Restaurar -> vuelve a la copia anterior
param([switch]$Restaurar, [string]$Archivo)  # -Archivo: solo para probar sobre una copia
$ErrorActionPreference = 'Stop'

$file = if ($Archivo) { $Archivo } else { "$env:USERPROFILE\AppData\LocalLow\Colossal Order\Cities Skylines II\Settings.coc" }
$dir  = Split-Path $file
if (-not (Test-Path $file)) { throw "No encuentro $file. Abre el juego una vez y cierralo." }
# El juego reescribe Settings.coc al cerrarse: si esta abierto, nuestros cambios se pierden.
if (-not $Archivo -and (Get-Process Cities2 -ErrorAction SilentlyContinue)) { throw "Cierra Cities: Skylines II primero y vuelve a correr esto." }

if ($Restaurar) {
    $bak = Get-ChildItem "$dir\Settings.coc.bak-*" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $bak) { throw "No hay copia de seguridad para restaurar." }
    Copy-Item $bak.FullName $file -Force
    "Restaurado desde $($bak.Name)"; return
}

Copy-Item $file "$file.bak-$(Get-Date -Format yyyyMMdd-HHmmss)"
$txt = [IO.File]::ReadAllText($file)

# Cambia "clave": valor dentro del bloque { ... "@type": "Game.Settings.<tipo>" }
function Set-Val([string]$tipo, [string]$clave, [string]$valor) {
    $bloque = '\{[^{}]*?"@type": "Game\.Settings\.' + $tipo + '"'
    $m = [regex]::Match($script:txt, $bloque)
    if (-not $m.Success) { Write-Warning "No esta el bloque $tipo (se omite)"; return }
    $nuevo = [regex]::Replace($m.Value, '("' + $clave + '": )[^,\r\n]+', '${1}' + $valor)
    $script:txt = $script:txt.Remove($m.Index, $m.Length).Insert($m.Index, $nuevo)
}

# Lo que mas FPS cuesta en una grafica integrada -> apagado
Set-Val 'VolumetricsQualitySettings'   'enabled' 'false'
Set-Val 'SSAOQualitySettings'          'enabled' 'false'
Set-Val 'SSRQualitySettings'           'enabled' 'false'
Set-Val 'SSGIQualitySettings'          'enabled' 'false'
Set-Val 'DepthOfFieldQualitySettings'  'enabled' 'false'
Set-Val 'MotionBlurQualitySettings'    'enabled' 'false'
Set-Val 'FogQualitySettings'           'enabled' 'false'
Set-Val 'CloudsQualitySettings'        'volumetricCloudsEnabled' 'false'
Set-Val 'CloudsQualitySettings'        'distanceCloudsEnabled' 'false'
# Bordes: FXAA es el antialias mas barato; sin MSAA en contornos
Set-Val 'AntiAliasingQualitySettings'  'antiAliasingMethod' '"FXAA"'
Set-Val 'AntiAliasingQualitySettings'  'outlinesMSAA' '"None"'
# Resolucion dinamica con FSR 1 a 50 %: la mayor ganancia de FPS
Set-Val 'DynamicResolutionScaleSettings' 'enabled' 'true'
Set-Val 'DynamicResolutionScaleSettings' 'upscaleFilter' '"EdgeAdaptiveScaling"'
Set-Val 'DynamicResolutionScaleSettings' 'minScale' '0.5'
# Sombras bajas (sin ellas la ciudad se ve plana)
Set-Val 'ShadowsQualitySettings'       'directionalShadowResolution' '512'
Set-Val 'ShadowsQualitySettings'       'terrainCastShadows' 'false'
# Menos detalle a lo lejos y menos luces: alivia los 4 GB de video
Set-Val 'LevelOfDetailQualitySettings' 'levelOfDetail' '0.25'
Set-Val 'LevelOfDetailQualitySettings' 'maxLightCount' '512'
Set-Val 'LevelOfDetailQualitySettings' 'meshMemoryBudget' '512'
Set-Val 'LevelOfDetailQualitySettings' 'lodCrossFade' 'false'
Set-Val 'TextureQualitySettings'       'mipbias' '2'
Set-Val 'WaterQualitySettings'         'waterflow' 'false'

[IO.File]::WriteAllText($file, $txt, (New-Object Text.UTF8Encoding $false))

# Comprobacion: los valores clave quedaron escritos
$check = [IO.File]::ReadAllText($file)
foreach ($t in 'SSAO','SSR','Volumetrics','DepthOfField','MotionBlur') {
    if ($check -notmatch ('"enabled": false,[^{}]*?"@type": "Game\.Settings\.' + $t)) { throw "Fallo al apagar $t; usa -Restaurar" }
}
"Listo. Graficos rapidos aplicados. Copia de seguridad guardada junto a Settings.coc."
