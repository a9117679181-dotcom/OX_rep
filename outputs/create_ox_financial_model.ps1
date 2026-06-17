Add-Type -AssemblyName System.IO.Compression

$ErrorActionPreference = "Stop"
$OutputPath = Join-Path $PSScriptRoot "OX_financial_model_ru.xlsx"

function Escape-Xml {
    param([object]$Value)
    if ($null -eq $Value) { return "" }
    return [System.Security.SecurityElement]::Escape([string]$Value)
}

function Convert-Value {
    param([string]$Value)
    if ($null -eq $Value) { return "" }
    $trimmed = $Value.Trim()
    if ($trimmed -eq "") { return "" }
    $number = 0.0
    if ([double]::TryParse($trimmed, [System.Globalization.NumberStyles]::Float, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$number)) {
        return $number
    }
    return $trimmed
}

function Convert-PipeTable {
    param([string]$Text, [int[]]$NumericColumns = @())
    $rows = @()
    foreach ($line in ($Text.Trim() -split "`n")) {
        $cells = @()
        $parts = $line.TrimEnd("`r") -split "\|", -1
        for ($i = 0; $i -lt $parts.Count; $i++) {
            if ($NumericColumns -contains ($i + 1)) {
                $cells += Convert-Value $parts[$i]
            } else {
                $cells += $parts[$i].Trim()
            }
        }
        $rows += ,$cells
    }
    return $rows
}

function Get-ColName {
    param([int]$Number)
    $name = ""
    while ($Number -gt 0) {
        $m = ($Number - 1) % 26
        $name = [char](65 + $m) + $name
        $Number = [math]::Floor(($Number - 1) / 26)
    }
    return $name
}

function Get-CellXml {
    param([int]$Row, [int]$Col, [object]$Value)
    $ref = "$(Get-ColName $Col)$Row"
    if ($null -eq $Value -or $Value -eq "") { return "<c r=""$ref""/>" }
    if ($Value -is [hashtable] -and $Value.ContainsKey("f")) {
        $formula = Escape-Xml $Value["f"]
        return "<c r=""$ref""><f>$formula</f></c>"
    }
    if ($Value -is [int] -or $Value -is [long] -or $Value -is [double] -or $Value -is [decimal]) {
        $num = ([double]$Value).ToString([System.Globalization.CultureInfo]::InvariantCulture)
        return "<c r=""$ref""><v>$num</v></c>"
    }
    $text = Escape-Xml $Value
    return "<c r=""$ref"" t=""inlineStr""><is><t>$text</t></is></c>"
}

function New-WorksheetXml {
    param([object[]]$Rows, [double[]]$Widths = @())
    $maxRows = [Math]::Max($Rows.Count, 1)
    $maxCols = 1
    foreach ($row in $Rows) { if ($row.Count -gt $maxCols) { $maxCols = $row.Count } }
    $dimension = "A1:$(Get-ColName $maxCols)$maxRows"
    $colsXml = ""
    if ($Widths.Count -gt 0) {
        $colParts = @()
        for ($i = 0; $i -lt $Widths.Count; $i++) {
            $idx = $i + 1
            $w = $Widths[$i].ToString([System.Globalization.CultureInfo]::InvariantCulture)
            $colParts += "<col min=""$idx"" max=""$idx"" width=""$w"" customWidth=""1""/>"
        }
        $colsXml = "<cols>$($colParts -join '')</cols>"
    }
    $rowParts = @()
    for ($i = 0; $i -lt $Rows.Count; $i++) {
        $r = $i + 1
        $cells = @()
        for ($j = 0; $j -lt $Rows[$i].Count; $j++) {
            $cells += Get-CellXml $r ($j + 1) $Rows[$i][$j]
        }
        $rowParts += "<row r=""$r"">$($cells -join '')</row>"
    }
    return @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <dimension ref="$dimension"/>
  <sheetViews><sheetView workbookViewId="0"/></sheetViews>
  <sheetFormatPr defaultRowHeight="15"/>
  $colsXml
  <sheetData>$($rowParts -join '')</sheetData>
  <pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/>
</worksheet>
"@
}

function ParamFormula {
    param([string]$Metric, [string]$ScenarioCell)
    return 'INDEX(Assumptions!$C:$E,MATCH("' + $Metric + '",Assumptions!$B:$B,0),MATCH(' + $ScenarioCell + ',Assumptions!$C$3:$E$3,0))'
}

function FormulaCell {
    param([string]$Formula)
    return @{ f = $Formula }
}

function Add-ZipEntry {
    param($Zip, [string]$EntryName, [string]$Content)
    $entry = $Zip.CreateEntry($EntryName)
    $stream = $entry.Open()
    $writer = [System.IO.StreamWriter]::new($stream, [System.Text.UTF8Encoding]::new($false))
    $writer.Write($Content)
    $writer.Dispose()
}

$assumptionsText = @"
OX Financial Model - Assumptions||||||
Date|2026-06-10|||||
Category|Metric|Conservative|Base|Upside|Unit / type|Source / note
Product economy|Prize pool share|0.80|0.80|0.80|% of valid GMV|Internal OX TZ: prize pool and jackpot
Product economy|Platform fee share|0.10|0.10|0.10|% of valid GMV|Internal OX TZ: platform fee
Product economy|Jackpot contribution share|0.10|0.10|0.10|% of valid GMV|Internal OX TZ: next jackpot contribution
Product economy|Gas reserve share of platform fee|0.20|0.20|0.20|% of platform fee|Internal OX TZ: MVP gas reserve
Product economy|Net platform margin before OPEX|0.08|0.08|0.08|% of valid GMV|Platform fee minus gas reserve
Product economy|Minimum public jackpot|5000|5000|5000|USDC|Internal OX TZ: MVP minimum jackpot
Funnel|Starting monthly visits|10000|30000|80000|visits|Hypothesis: first live country/month
Funnel|Monthly visit growth|0.10|0.18|0.28|% m/m|Scenario assumption
Funnel|Eligible user rate after geo/compliance|0.75|0.82|0.88|% of visits|After blocked country/VPN/proxy/compliance filters
Funnel|Wallet connect rate|0.12|0.18|0.25|% of eligible users|UX/onboarding assumption
Funnel|USDC readiness rate|0.55|0.65|0.75|% of connected wallets|User can buy with USDC
Funnel|First purchase conversion|0.25|0.32|0.40|% of USDC-ready users|Ticket purchase conversion
Funnel|Repeat purchase rate|0.30|0.42|0.55|% of previous active users|Monthly repeat behavior
Funnel|Tickets per active user per month|1.40|2.20|3.10|tickets|Frequency assumption
Funnel|Average ticket|8|15|25|USDC|Average total ticket price
Partner economics|Partner share of first buyers|0.50|0.60|0.65|%|Share of new buyers attributed to partners
Partner economics|CPA per qualified player|15|15|15|USDC|Internal OX TZ: CPA hypothesis, not guarantee
Partner economics|CPA approved rate|0.65|0.75|0.82|%|After fraud/quality review
Compliance|KYC required rate|0.03|0.05|0.07|% of active users|High-value/risk-triggered KYC
Compliance|KYC cost per checked user|2.50|2.00|1.80|USDC|Provider hypothesis
Variable costs|Support cost per active user|0.30|0.25|0.20|USDC/month|Support and ops variable load
Fixed costs|Monthly product/dev/ops cost|100000|140000|220000|USDC/month|Team and operations
Fixed costs|Monthly marketing fixed budget|10000|25000|60000|USDC/month|Non-CPA marketing/content/community
Fixed costs|Monthly legal/compliance reserve|10000|15000|25000|USDC/month|Legal, country memos, licensing work
Fixed costs|Monthly oracle/data cost|5000|8000|15000|USDC/month|Sports data APIs and result verification
Fixed costs|Monthly infrastructure cost|4000|8000|20000|USDC/month|Hosting, indexer, monitoring, backups
Fixed costs|Monthly audit/security reserve|5000|7000|10000|USDC/month|Audit/security reserve
Risk reserve|Monthly jackpot top-up reserve|5000|8000|12000|USDC/month|Support reserve for 5,000 USDC public jackpot
Funding|Runway target|18|18|18|months|Funding planning
Funding|Initial cash buffer|100000|150000|250000|USDC|Operational contingency
"@

$countryText = @"
Queue|Country / region|Localization|Launch status|Main launch gates|Digital / market signal|Crypto / payment signal|Primary GTM channels|Source / note
1|Nigeria|English first|Candidate for first legal analysis|Federal/state betting or lottery classification; crypto payments; AML; advertising; taxes|DataReportal 2025: 107M internet users, 150M mobile connections|Chainalysis 2025: rank 6 global crypto adoption|Football media, Telegram/X, sports influencers, affiliates, crypto communities|https://datareportal.com/reports/digital-2025-nigeria; https://www.chainalysis.com/blog/2025-global-crypto-adoption-index/
1|Kenya|English + Swahili|Candidate for first legal analysis|GRA licensing; Gambling Control Act 2025; online gambling; advertising; responsible gaming; crypto payments|DataReportal 2025: 27.4M internet users; mobile connections 121% population|Requires country-specific USDC/payment memo|Sports media, mobile-first partners, football communities, compliant influencers|https://datareportal.com/reports/digital-2025-kenya; https://gra.go.ke/about/
2|Ghana|English|Second-wave candidate|Gaming Commission licensing; AML/CFT; advertising; payment rules; crypto treatment|DataReportal 2025: 24.3M internet users; 69.9% penetration|Requires country-specific crypto/payment memo|Football pages, Facebook/YouTube, sports media, affiliates|https://datareportal.com/reports/digital-2025-ghana; https://www.gamingcommission.gov.gh/
2|Tanzania|Swahili + English support|Second-wave candidate|Gaming Board licensing; online gaming; payment/KYC; advertising|DataReportal 2025: 79M mobile connections; 20.2M internet users|Requires country-specific crypto/payment memo|Swahili sports communities, local affiliates, football media|https://datareportal.com/reports/digital-2025-tanzania; https://www.gamingboard.go.tz/
2|Uganda|English|Second-wave candidate|NLGRB licensing; responsible gaming; advertising; payment/KYC|DataReportal 2025: 38.6M mobile connections; 14.2M internet users|Requires country-specific crypto/payment memo|Sports communities, regional affiliates, responsible gaming campaigns|https://datareportal.com/reports/digital-2025-uganda; https://lgrb.go.ug/
2|Zambia|English|Second-wave candidate|Betting licensing; tax; advertising; crypto payments; AML|DataReportal 2025: 19.9M mobile connections; 7.13M internet users|Requires country-specific crypto/payment memo|Focused partner tests, sports media, low-budget cohorts|https://datareportal.com/reports/digital-2025-zambia
3 / watchlist|Brazil|Portuguese|Watchlist only|Local authorization; .bet.br; local entity; consumer protection; likely crypto-payment restrictions|Large football/digital market|Chainalysis 2025: rank 5; payment legality must be confirmed|Only after local counsel and payment route|https://www.gov.br/fazenda/pt-br/composicao/orgaos/secretaria-de-premios-e-apostas
3 / watchlist|Kazakhstan|Russian/Kazakh|Watchlist only|License; payments; server/data requirements; crypto treatment; sanctions/AML|Commercially relevant regional audience|Requires legal/payment memo|Only after local legal clearance|Internal TZ watchlist
3 / watchlist|Uzbekistan|Uzbek/Russian|Watchlist only|Gambling/payment/ads/KYC uncertainty|Potential Central Asia market|Requires legal/payment memo|Only after explicit legal route|Internal TZ watchlist
3 / watchlist|South Africa|English|Watchlist only|Provincial betting license; online restrictions; crypto payment uncertainty|Commercially attractive but complex|Requires payment and license memo|Only with local licensing route|Internal TZ watchlist
3 / watchlist|Vietnam|Vietnamese|Watchlist only|Gambling restrictions for residents; advertising; payments|High digital/crypto interest but high legal risk|Requires explicit legal route|Do not target before legal clearance|Internal TZ watchlist
3 / watchlist|Philippines|English/Filipino|Watchlist only|Post-POGO/IGL reputational and licensing risk; local law|Gaming infrastructure history|Requires reputational/legal review|Do not treat as core launch|Internal TZ watchlist
Red zone|US, Canada, UK, EU/EEA, Australia, India, Indonesia, China, Russia/Belarus, Turkey, Gulf restricted markets, sanctions territories|N/A|Blocked for MVP|No targeting or purchase permit without separate license/approval|High regulatory/sanctions/advertising risk|Not eligible for MVP|No marketing|Internal TZ red zone
"@

$assumptions = Convert-PipeTable $assumptionsText @(3,4,5)
$countryRows = Convert-PipeTable $countryText @()

function Build-FunnelRows {
    $rows = @()
    $rows += ,@("Month", "Scenario", "Countries active", "Visits", "Eligible users", "Wallet connected", "USDC ready", "First buyers", "Repeat buyers", "Active paying users")
    foreach ($scenario in @("Conservative", "Base", "Upside")) {
        for ($month = 1; $month -le 36; $month++) {
            $r = $rows.Count + 1
            $prevActive = if ($month -eq 1) { "0" } else { "J$($r - 1)" }
            $rows += ,@(
                $month,
                $scenario,
                (FormulaCell "IF(A$r<7,1,IF(A$r<13,2,IF(A$r<24,3,4)))"),
                (FormulaCell "$(ParamFormula 'Starting monthly visits' "B$r")*POWER(1+$(ParamFormula 'Monthly visit growth' "B$r"),A$r-1)*C$r"),
                (FormulaCell "D$r*$(ParamFormula 'Eligible user rate after geo/compliance' "B$r")"),
                (FormulaCell "E$r*$(ParamFormula 'Wallet connect rate' "B$r")"),
                (FormulaCell "F$r*$(ParamFormula 'USDC readiness rate' "B$r")"),
                (FormulaCell "G$r*$(ParamFormula 'First purchase conversion' "B$r")"),
                (FormulaCell "$prevActive*$(ParamFormula 'Repeat purchase rate' "B$r")"),
                (FormulaCell "H$r+I$r")
            )
        }
    }
    return $rows
}

function Build-RevenueRows {
    $rows = @()
    $rows += ,@("Month", "Scenario", "Active users", "Tickets sold", "Average ticket", "GMV", "Prize pool", "Platform fee", "Jackpot contribution", "Gas reserve", "Net platform revenue before OPEX")
    foreach ($scenario in @("Conservative", "Base", "Upside")) {
        for ($month = 1; $month -le 36; $month++) {
            $r = $rows.Count + 1
            $rows += ,@(
                $month,
                $scenario,
                (FormulaCell "SUMIFS(Funnel!`$J:`$J,Funnel!`$A:`$A,A$r,Funnel!`$B:`$B,B$r)"),
                (FormulaCell "C$r*$(ParamFormula 'Tickets per active user per month' "B$r")"),
                (FormulaCell "$(ParamFormula 'Average ticket' "B$r")"),
                (FormulaCell "D$r*E$r"),
                (FormulaCell "F$r*$(ParamFormula 'Prize pool share' "B$r")"),
                (FormulaCell "F$r*$(ParamFormula 'Platform fee share' "B$r")"),
                (FormulaCell "F$r*$(ParamFormula 'Jackpot contribution share' "B$r")"),
                (FormulaCell "H$r*$(ParamFormula 'Gas reserve share of platform fee' "B$r")"),
                (FormulaCell "H$r-J$r")
            )
        }
    }
    return $rows
}

function Build-CostRows {
    $rows = @()
    $rows += ,@("Month", "Scenario", "First buyers", "Active users", "CPA cost", "Marketing fixed", "KYC cost", "Support variable", "Product/dev/ops", "Legal/compliance", "Oracle/data", "Infrastructure", "Audit/security", "Jackpot top-up reserve", "Total costs")
    foreach ($scenario in @("Conservative", "Base", "Upside")) {
        for ($month = 1; $month -le 36; $month++) {
            $r = $rows.Count + 1
            $rows += ,@(
                $month,
                $scenario,
                (FormulaCell "SUMIFS(Funnel!`$H:`$H,Funnel!`$A:`$A,A$r,Funnel!`$B:`$B,B$r)"),
                (FormulaCell "SUMIFS(Funnel!`$J:`$J,Funnel!`$A:`$A,A$r,Funnel!`$B:`$B,B$r)"),
                (FormulaCell "C$r*$(ParamFormula 'Partner share of first buyers' "B$r")*$(ParamFormula 'CPA per qualified player' "B$r")*$(ParamFormula 'CPA approved rate' "B$r")"),
                (FormulaCell "$(ParamFormula 'Monthly marketing fixed budget' "B$r")"),
                (FormulaCell "D$r*$(ParamFormula 'KYC required rate' "B$r")*$(ParamFormula 'KYC cost per checked user' "B$r")"),
                (FormulaCell "D$r*$(ParamFormula 'Support cost per active user' "B$r")"),
                (FormulaCell "$(ParamFormula 'Monthly product/dev/ops cost' "B$r")"),
                (FormulaCell "$(ParamFormula 'Monthly legal/compliance reserve' "B$r")"),
                (FormulaCell "$(ParamFormula 'Monthly oracle/data cost' "B$r")"),
                (FormulaCell "$(ParamFormula 'Monthly infrastructure cost' "B$r")"),
                (FormulaCell "$(ParamFormula 'Monthly audit/security reserve' "B$r")"),
                (FormulaCell "$(ParamFormula 'Monthly jackpot top-up reserve' "B$r")"),
                (FormulaCell "SUM(E$r:N$r)")
            )
        }
    }
    return $rows
}

function Build-UnitRows {
    $rows = @()
    $rows += ,@("Month", "Scenario", "GMV", "Net platform revenue", "Total costs", "First buyers", "Active users", "CAC", "ARPPU", "Net revenue / active user", "Contribution margin", "Payback months", "Break-even monthly GMV")
    foreach ($scenario in @("Conservative", "Base", "Upside")) {
        for ($month = 1; $month -le 36; $month++) {
            $r = $rows.Count + 1
            $rows += ,@(
                $month,
                $scenario,
                (FormulaCell "SUMIFS(Revenue!`$F:`$F,Revenue!`$A:`$A,A$r,Revenue!`$B:`$B,B$r)"),
                (FormulaCell "SUMIFS(Revenue!`$K:`$K,Revenue!`$A:`$A,A$r,Revenue!`$B:`$B,B$r)"),
                (FormulaCell "SUMIFS(Costs!`$O:`$O,Costs!`$A:`$A,A$r,Costs!`$B:`$B,B$r)"),
                (FormulaCell "SUMIFS(Costs!`$C:`$C,Costs!`$A:`$A,A$r,Costs!`$B:`$B,B$r)"),
                (FormulaCell "SUMIFS(Costs!`$D:`$D,Costs!`$A:`$A,A$r,Costs!`$B:`$B,B$r)"),
                (FormulaCell "IF(F$r=0,0,(SUMIFS(Costs!`$E:`$E,Costs!`$A:`$A,A$r,Costs!`$B:`$B,B$r)+SUMIFS(Costs!`$F:`$F,Costs!`$A:`$A,A$r,Costs!`$B:`$B,B$r))/F$r)"),
                (FormulaCell "IF(G$r=0,0,C$r/G$r)"),
                (FormulaCell "IF(G$r=0,0,D$r/G$r)"),
                (FormulaCell "D$r-E$r"),
                (FormulaCell "IF(J$r<=0,0,H$r/J$r)"),
                (FormulaCell "IF($(ParamFormula 'Net platform margin before OPEX' "B$r")=0,0,E$r/$(ParamFormula 'Net platform margin before OPEX' "B$r"))")
            )
        }
    }
    return $rows
}

$scenariosRows = @()
$scenariosRows += ,@("Metric", "Conservative", "Base", "Upside", "Comment")
$scenariosRows += ,@("12M GMV", (FormulaCell 'SUMIFS(Revenue!$F:$F,Revenue!$B:$B,B$1,Revenue!$A:$A,"<=12")'), (FormulaCell 'SUMIFS(Revenue!$F:$F,Revenue!$B:$B,C$1,Revenue!$A:$A,"<=12")'), (FormulaCell 'SUMIFS(Revenue!$F:$F,Revenue!$B:$B,D$1,Revenue!$A:$A,"<=12")'), "Valid ticket volume")
$scenariosRows += ,@("12M Net Platform Revenue", (FormulaCell 'SUMIFS(Revenue!$K:$K,Revenue!$B:$B,B$1,Revenue!$A:$A,"<=12")'), (FormulaCell 'SUMIFS(Revenue!$K:$K,Revenue!$B:$B,C$1,Revenue!$A:$A,"<=12")'), (FormulaCell 'SUMIFS(Revenue!$K:$K,Revenue!$B:$B,D$1,Revenue!$A:$A,"<=12")'), "Platform fee minus gas reserve")
$scenariosRows += ,@("12M Total Costs", (FormulaCell 'SUMIFS(Costs!$O:$O,Costs!$B:$B,B$1,Costs!$A:$A,"<=12")'), (FormulaCell 'SUMIFS(Costs!$O:$O,Costs!$B:$B,C$1,Costs!$A:$A,"<=12")'), (FormulaCell 'SUMIFS(Costs!$O:$O,Costs!$B:$B,D$1,Costs!$A:$A,"<=12")'), "OPEX plus variable costs and reserves")
$scenariosRows += ,@("24M GMV", (FormulaCell 'SUMIFS(Revenue!$F:$F,Revenue!$B:$B,B$1,Revenue!$A:$A,"<=24")'), (FormulaCell 'SUMIFS(Revenue!$F:$F,Revenue!$B:$B,C$1,Revenue!$A:$A,"<=24")'), (FormulaCell 'SUMIFS(Revenue!$F:$F,Revenue!$B:$B,D$1,Revenue!$A:$A,"<=24")'), "Valid ticket volume")
$scenariosRows += ,@("24M Net Platform Revenue", (FormulaCell 'SUMIFS(Revenue!$K:$K,Revenue!$B:$B,B$1,Revenue!$A:$A,"<=24")'), (FormulaCell 'SUMIFS(Revenue!$K:$K,Revenue!$B:$B,C$1,Revenue!$A:$A,"<=24")'), (FormulaCell 'SUMIFS(Revenue!$K:$K,Revenue!$B:$B,D$1,Revenue!$A:$A,"<=24")'), "Platform fee minus gas reserve")
$scenariosRows += ,@("24M Total Costs", (FormulaCell 'SUMIFS(Costs!$O:$O,Costs!$B:$B,B$1,Costs!$A:$A,"<=24")'), (FormulaCell 'SUMIFS(Costs!$O:$O,Costs!$B:$B,C$1,Costs!$A:$A,"<=24")'), (FormulaCell 'SUMIFS(Costs!$O:$O,Costs!$B:$B,D$1,Costs!$A:$A,"<=24")'), "OPEX plus variable costs and reserves")
$scenariosRows += ,@("36M GMV", (FormulaCell 'SUMIFS(Revenue!$F:$F,Revenue!$B:$B,B$1)'), (FormulaCell 'SUMIFS(Revenue!$F:$F,Revenue!$B:$B,C$1)'), (FormulaCell 'SUMIFS(Revenue!$F:$F,Revenue!$B:$B,D$1)'), "Valid ticket volume")
$scenariosRows += ,@("36M Net Platform Revenue", (FormulaCell 'SUMIFS(Revenue!$K:$K,Revenue!$B:$B,B$1)'), (FormulaCell 'SUMIFS(Revenue!$K:$K,Revenue!$B:$B,C$1)'), (FormulaCell 'SUMIFS(Revenue!$K:$K,Revenue!$B:$B,D$1)'), "Platform fee minus gas reserve")
$scenariosRows += ,@("36M Total Costs", (FormulaCell 'SUMIFS(Costs!$O:$O,Costs!$B:$B,B$1)'), (FormulaCell 'SUMIFS(Costs!$O:$O,Costs!$B:$B,C$1)'), (FormulaCell 'SUMIFS(Costs!$O:$O,Costs!$B:$B,D$1)'), "OPEX plus variable costs and reserves")
$scenariosRows += ,@("Scenario interpretation", "Slow legal/GTM, high CAC, low retention", "Controlled launch in Nigeria/Kenya then selective queue 2", "Fast partner growth with stronger retention", "Narrative")

$sensitivityRows = @()
$sensitivityRows += ,@("Variable", "Downside", "Base", "Upside", "Interpretation / formula")
$sensitivityRows += ,@("CPA per qualified player", 25, 15, 10, "Higher CPA increases CAC and payback period")
$sensitivityRows += ,@("Average ticket", 8, 15, 25, "Lower ticket requires more users for same GMV")
$sensitivityRows += ,@("Repeat purchase rate", 0.25, 0.42, 0.60, "Retention is the key LTV driver")
$sensitivityRows += ,@("First purchase conversion", 0.20, 0.32, 0.45, "UX/onboarding pressure point")
$sensitivityRows += ,@("Net platform margin before OPEX", 0.06, 0.08, 0.09, "Gas and fee structure sensitivity")
$sensitivityRows += ,@("Monthly fixed costs", 220000, 180000, 140000, "Lean operation lowers break-even GMV")
$sensitivityRows += ,@("Break-even GMV at downside/base/upside margin", (FormulaCell "B7/B6"), (FormulaCell "C7/C6"), (FormulaCell "D7/D6"), "Fixed costs / net platform margin")
$sensitivityRows += ,@("Stress test: CPA +50%", (FormulaCell "Assumptions!D20*1.5"), "", "", "Apply to Costs CPA formula in duplicate model if needed")
$sensitivityRows += ,@("Stress test: ticket -30%", (FormulaCell "Assumptions!D18*0.7"), "", "", "Apply to Revenue average ticket if needed")
$sensitivityRows += ,@("Stress test: retention -50%", (FormulaCell "Assumptions!D16*0.5"), "", "", "Apply to Funnel repeat purchase if needed")

$investorRows = @()
$investorRows += ,@("Scenario", "12M GMV", "12M net revenue", "12M costs", "12M net cash need", "24M GMV", "24M net revenue", "24M costs", "36M GMV", "36M net revenue", "36M costs", "Avg monthly break-even GMV", "Funding need for 18M runway")
foreach ($scenario in @("Conservative", "Base", "Upside")) {
    $r = $investorRows.Count + 1
    $investorRows += ,@(
        $scenario,
        (FormulaCell "SUMIFS(Revenue!`$F:`$F,Revenue!`$B:`$B,A$r,Revenue!`$A:`$A,""<=12"")"),
        (FormulaCell "SUMIFS(Revenue!`$K:`$K,Revenue!`$B:`$B,A$r,Revenue!`$A:`$A,""<=12"")"),
        (FormulaCell "SUMIFS(Costs!`$O:`$O,Costs!`$B:`$B,A$r,Costs!`$A:`$A,""<=12"")"),
        (FormulaCell "MAX(0,D$r-C$r)"),
        (FormulaCell "SUMIFS(Revenue!`$F:`$F,Revenue!`$B:`$B,A$r,Revenue!`$A:`$A,""<=24"")"),
        (FormulaCell "SUMIFS(Revenue!`$K:`$K,Revenue!`$B:`$B,A$r,Revenue!`$A:`$A,""<=24"")"),
        (FormulaCell "SUMIFS(Costs!`$O:`$O,Costs!`$B:`$B,A$r,Costs!`$A:`$A,""<=24"")"),
        (FormulaCell "SUMIFS(Revenue!`$F:`$F,Revenue!`$B:`$B,A$r)"),
        (FormulaCell "SUMIFS(Revenue!`$K:`$K,Revenue!`$B:`$B,A$r)"),
        (FormulaCell "SUMIFS(Costs!`$O:`$O,Costs!`$B:`$B,A$r)"),
        (FormulaCell "AVERAGEIFS(Unit_Economics!`$M:`$M,Unit_Economics!`$B:`$B,A$r,Unit_Economics!`$A:`$A,""<=12"")"),
        (FormulaCell "MAX(0,SUMIFS(Costs!`$O:`$O,Costs!`$B:`$B,A$r,Costs!`$A:`$A,""<=18"")-SUMIFS(Revenue!`$K:`$K,Revenue!`$B:`$B,A$r,Revenue!`$A:`$A,""<=18""))+INDEX(Assumptions!`$C:`$E,MATCH(""Initial cash buffer"",Assumptions!`$B:`$B,0),MATCH(A$r,Assumptions!`$C`$3:`$E`$3,0))")
    )
}
$investorRows += ,@("Notes", "Funding need is model output, not fundraising ask", "", "", "", "", "", "", "", "", "", "", "Requires legal/licensing and team budget validation")

$sheets = @(
    @{ Name = "Assumptions"; Rows = $assumptions; Widths = @(22,34,16,16,16,18,44) },
    @{ Name = "Country Rollout"; Rows = $countryRows; Widths = @(14,24,24,22,52,44,42,42,64) },
    @{ Name = "Funnel"; Rows = (Build-FunnelRows); Widths = @(10,16,16,16,16,18,16,16,16,20) },
    @{ Name = "Revenue"; Rows = (Build-RevenueRows); Widths = @(10,16,16,16,16,16,16,16,22,16,28) },
    @{ Name = "Costs"; Rows = (Build-CostRows); Widths = @(10,16,16,16,16,18,16,18,18,18,16,16,18,22,16) },
    @{ Name = "Unit_Economics"; Rows = (Build-UnitRows); Widths = @(10,16,16,22,16,16,16,16,16,24,22,18,26) },
    @{ Name = "Scenarios"; Rows = $scenariosRows; Widths = @(30,22,22,22,42) },
    @{ Name = "Sensitivity"; Rows = $sensitivityRows; Widths = @(36,18,18,18,48) },
    @{ Name = "Investor Summary"; Rows = $investorRows; Widths = @(16,16,18,16,20,16,18,16,16,18,16,28,28) }
)

$sheetXmlParts = @()
$sheetRelParts = @()
$contentOverrideParts = @()
for ($i = 0; $i -lt $sheets.Count; $i++) {
    $id = $i + 1
    $sheetName = Escape-Xml $sheets[$i].Name
    $sheetXmlParts += "<sheet name=""$sheetName"" sheetId=""$id"" r:id=""rId$id""/>"
    $sheetRelParts += "<Relationship Id=""rId$id"" Type=""http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet"" Target=""worksheets/sheet$id.xml""/>"
    $contentOverrideParts += "<Override PartName=""/xl/worksheets/sheet$id.xml"" ContentType=""application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml""/>"
}
$stylesRelId = $sheets.Count + 1
$sheetRelParts += "<Relationship Id=""rId$stylesRelId"" Type=""http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles"" Target=""styles.xml""/>"

$workbookXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <fileVersion appName="xl"/>
  <workbookPr date1904="false"/>
  <bookViews><workbookView xWindow="0" yWindow="0" windowWidth="28800" windowHeight="17600"/></bookViews>
  <sheets>$($sheetXmlParts -join '')</sheets>
  <calcPr calcId="191029" fullCalcOnLoad="1" forceFullCalc="1"/>
</workbook>
"@

$workbookRels = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
$($sheetRelParts -join "`n")
</Relationships>
"@

$contentTypes = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
$($contentOverrideParts -join "`n")
  <Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>
  <Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
  <Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>
</Types>
"@

$rootRels = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>
</Relationships>
"@

$stylesXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
  <fonts count="1"><font><sz val="11"/><color theme="1"/><name val="Calibri"/><family val="2"/></font></fonts>
  <fills count="2"><fill><patternFill patternType="none"/></fill><fill><patternFill patternType="gray125"/></fill></fills>
  <borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>
  <cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>
  <cellXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/></cellXfs>
  <cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles>
</styleSheet>
"@

$coreXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcmitype="http://purl.org/dc/dcmitype/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <dc:title>OX financial model</dc:title>
  <dc:creator>Codex</dc:creator>
  <cp:lastModifiedBy>Codex</cp:lastModifiedBy>
  <dcterms:created xsi:type="dcterms:W3CDTF">2026-06-10T12:00:00Z</dcterms:created>
  <dcterms:modified xsi:type="dcterms:W3CDTF">2026-06-10T12:00:00Z</dcterms:modified>
</cp:coreProperties>
"@

$titles = ($sheets | ForEach-Object { "<vt:lpstr>$(Escape-Xml $_.Name)</vt:lpstr>" }) -join ""
$appXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties" xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes">
  <Application>Microsoft Excel</Application>
  <DocSecurity>0</DocSecurity>
  <ScaleCrop>false</ScaleCrop>
  <HeadingPairs><vt:vector size="2" baseType="variant"><vt:variant><vt:lpstr>Worksheets</vt:lpstr></vt:variant><vt:variant><vt:i4>$($sheets.Count)</vt:i4></vt:variant></vt:vector></HeadingPairs>
  <TitlesOfParts><vt:vector size="$($sheets.Count)" baseType="lpstr">$titles</vt:vector></TitlesOfParts>
  <Company>OX</Company>
</Properties>
"@

$fileStream = [System.IO.File]::Open($OutputPath, [System.IO.FileMode]::Create, [System.IO.FileAccess]::ReadWrite)
try {
    $zip = [System.IO.Compression.ZipArchive]::new($fileStream, [System.IO.Compression.ZipArchiveMode]::Create, $true)
    try {
        Add-ZipEntry $zip "[Content_Types].xml" $contentTypes
        Add-ZipEntry $zip "_rels/.rels" $rootRels
        Add-ZipEntry $zip "docProps/core.xml" $coreXml
        Add-ZipEntry $zip "docProps/app.xml" $appXml
        Add-ZipEntry $zip "xl/workbook.xml" $workbookXml
        Add-ZipEntry $zip "xl/_rels/workbook.xml.rels" $workbookRels
        Add-ZipEntry $zip "xl/styles.xml" $stylesXml
        for ($i = 0; $i -lt $sheets.Count; $i++) {
            $id = $i + 1
            Add-ZipEntry $zip "xl/worksheets/sheet$id.xml" (New-WorksheetXml $sheets[$i].Rows $sheets[$i].Widths)
        }
    } finally {
        $zip.Dispose()
    }
} finally {
    $fileStream.Dispose()
}

Write-Output $OutputPath
