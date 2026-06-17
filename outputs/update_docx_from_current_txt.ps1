Add-Type -AssemblyName System.IO.Compression

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$Generator = Join-Path $PSScriptRoot "create_russian_deliverables.ps1"

$source = Get-Content -LiteralPath $Generator -Raw -Encoding UTF8
$marker = "# Markdown-файл является основным русским исходником"
$markerIndex = $source.IndexOf($marker)
if ($markerIndex -lt 0) {
    throw "Не найден маркер конца функций в $Generator"
}

$functionsStart = $source.IndexOf("function Escape-Xml")
if ($functionsStart -lt 0) {
    throw "Не найдено начало функций в $Generator"
}

$functionSource = "Add-Type -AssemblyName System.IO.Compression`n" + $source.Substring($functionsStart, $markerIndex - $functionsStart)
Invoke-Expression $functionSource

function Convert-One {
    param([string]$TxtPath, [string]$DocxPath)

    $absoluteTxt = Join-Path $Root $TxtPath
    $absoluteDocx = Join-Path $Root $DocxPath

    try {
        New-DocxFromMarkdown $absoluteTxt $absoluteDocx
        Write-Output $absoluteDocx
    } catch {
        $dir = Split-Path -Parent $absoluteDocx
        $base = [System.IO.Path]::GetFileNameWithoutExtension($absoluteDocx)
        $fallback = Join-Path $dir ($base + "_обновлено.docx")
        New-DocxFromMarkdown $absoluteTxt $fallback
        Write-Warning "Файл занят, создана обновленная копия: $fallback"
        Write-Output $fallback
    }
}

$pairs = @(
    @("ТЗ_OX_TXT\02_Этап_01_Ядро_продукта\OX_Этап_01_Ядро_продукта_ТЗ_v3.txt", "ТЗ_OX\02_Этап_01_Ядро_продукта\OX_Этап_01_Ядро_продукта_ТЗ_v3.docx"),
    @("ТЗ_OX_TXT\02_Этап_01_Ядро_продукта\00_Пояснительная_записка\OX_Этап_01_Пояснительная_записка_Ядро_продукта_v3.txt", "ТЗ_OX\02_Этап_01_Ядро_продукта\00_Пояснительная_записка\OX_Этап_01_Пояснительная_записка_Ядро_продукта_v3.docx"),
    @("ТЗ_OX_TXT\05_Этап_04_Призовой_фонд_и_джекпот\OX_Этап_04_Призовой_фонд_и_джекпот_ТЗ_v2.txt", "ТЗ_OX\05_Этап_04_Призовой_фонд_и_джекпот\OX_Этап_04_Призовой_фонд_и_джекпот_ТЗ_v2.docx"),
    @("ТЗ_OX_TXT\05_Этап_04_Призовой_фонд_и_джекпот\00_Пояснительная_записка\OX_Этап_04_Пояснительная_записка_Призовой_фонд_и_джекпот_v2.txt", "ТЗ_OX\05_Этап_04_Призовой_фонд_и_джекпот\00_Пояснительная_записка\OX_Этап_04_Пояснительная_записка_Призовой_фонд_и_джекпот_v2.docx"),
    @("ТЗ_OX_TXT\06_Этап_05_Защита_от_кита\OX_Этап_05_Защита_от_кита_ТЗ_v3.txt", "ТЗ_OX\06_Этап_05_Защита_от_кита\OX_Этап_05_Защита_от_кита_ТЗ_v3.docx"),
    @("ТЗ_OX_TXT\06_Этап_05_Защита_от_кита\00_Пояснительная_записка\OX_Этап_05_Пояснительная_записка_Защита_от_кита_v3.txt", "ТЗ_OX\06_Этап_05_Защита_от_кита\00_Пояснительная_записка\OX_Этап_05_Пояснительная_записка_Защита_от_кита_v3.docx"),
    @("ТЗ_OX_TXT\07_Этап_06_Автоматические_выплаты\OX_Этап_06_Автоматические_выплаты_ТЗ_v3.txt", "ТЗ_OX\07_Этап_06_Автоматические_выплаты\OX_Этап_06_Автоматические_выплаты_ТЗ_v3.docx"),
    @("ТЗ_OX_TXT\07_Этап_06_Автоматические_выплаты\00_Пояснительная_записка\OX_Этап_06_Пояснительная_записка_Автоматические_выплаты_v3.txt", "ТЗ_OX\07_Этап_06_Автоматические_выплаты\00_Пояснительная_записка\OX_Этап_06_Пояснительная_записка_Автоматические_выплаты_v3.docx"),
    @("ТЗ_OX_TXT\09_Этап_08_Смарт_контракты\OX_Этап_08_Смарт_контракты_ТЗ_v2.txt", "ТЗ_OX\09_Этап_08_Смарт_контракты\OX_Этап_08_Смарт_контракты_ТЗ_v2.docx"),
    @("ТЗ_OX_TXT\09_Этап_08_Смарт_контракты\00_Пояснительная_записка\OX_Этап_08_Пояснительная_записка_Смарт_контракты_v2.txt", "ТЗ_OX\09_Этап_08_Смарт_контракты\00_Пояснительная_записка\OX_Этап_08_Пояснительная_записка_Смарт_контракты_v2.docx")
)

foreach ($pair in $pairs) {
    Convert-One $pair[0] $pair[1]
}



