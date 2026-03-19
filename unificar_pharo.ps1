# 1. Obtener la ruta de la carpeta donde se está ejecutando el script
$currentFolder = Get-Item .

# 2. Validar que la carpeta se llame exactamente "pharo"
if ($currentFolder.Name -ne "pharo") {
    Write-Host "ERROR: La carpeta actual es '$($currentFolder.Name)'. El script solo corre en 'pharo'." -ForegroundColor Red
    return
}

$outputFile = "data.txt"
$scriptName = $MyInvocation.MyCommand.Name

# 3. Obtener todos los archivos excepto el script mismo y el archivo de salida (data.txt)
$files = Get-ChildItem -File | Where-Object { $_.Name -ne $scriptName -and $_.Name -ne $outputFile }

if ($files.Count -eq 0) {
    Write-Host "No hay archivos para procesar." -ForegroundColor Yellow
    return
}

# Limpiar el archivo data.txt si ya existe antes de empezar
if (Test-Path $outputFile) { Remove-Item $outputFile }

foreach ($file in $files) {
    Write-Host "Procesando: $($file.Name)..." -ForegroundColor Cyan
    
    # 4. Escribir el nombre del archivo y luego su contenido en data.txt
    "--- NOMBRE DE ARCHIVO: $($file.Name) ---" | Out-File -FilePath $outputFile -Append -Encoding utf8
    Get-Content -Path $file.FullName | Out-File -FilePath $outputFile -Append -Encoding utf8
    "`n" | Out-File -FilePath $outputFile -Append # Espacio en blanco entre archivos
    
    # 5. Borrar el archivo original después de procesarlo
    Remove-Item -Path $file.FullName -Force
}

Write-Host "¡Proceso terminado! Todo se guardó en $outputFile y los originales fueron borrados." -ForegroundColor Green