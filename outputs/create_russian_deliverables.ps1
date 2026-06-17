Add-Type -AssemblyName System.IO.Compression

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$SourceMd = Join-Path $PSScriptRoot "OX_user_country_financial_model_investor_ru.md"
$RuMd = Join-Path $PSScriptRoot "OX_анализ_пользователей_стран_и_финансовой_модели_для_инвестора.md"
$RuXlsx = Join-Path $PSScriptRoot "OX_финансовая_модель_для_инвестора.xlsx"
$RuDocx = Join-Path $PSScriptRoot "OX_анализ_пользователей_стран_и_финансовой_модели_для_инвестора.docx"
$DeepAnalyticsMd = Join-Path $PSScriptRoot "OX_глубокая_аналитика_стран_конкурентов_и_мягкого_входа.md"
$DeepAnalyticsDocx = Join-Path $PSScriptRoot "OX_глубокая_аналитика_стран_конкурентов_и_мягкого_входа.docx"
$DeepAnalyticsDocxUpdate = Join-Path $PSScriptRoot "OX_глубокая_аналитика_стран_конкурентов_и_мягкого_входа_обновлено_выплаты.docx"
$CompetitorAnalysisMd = Join-Path $PSScriptRoot "OX_анализ_конкурентов_рынка_и_уникальности.md"
$CompetitorAnalysisDocx = Join-Path $PSScriptRoot "OX_анализ_конкурентов_рынка_и_уникальности.docx"
$CompetitorAnalysisDocxUpdate = Join-Path $PSScriptRoot "OX_анализ_конкурентов_рынка_и_уникальности_обновлено_1xbet_1xbit.docx"
$RuXlsxCountryUpdate = Join-Path $PSScriptRoot "OX_финансовая_модель_для_инвестора_обновлено_очереди_стран.xlsx"
$RuDocxCountryUpdate = Join-Path $PSScriptRoot "OX_анализ_пользователей_стран_и_финансовой_модели_для_инвестора_обновлено_очереди_стран.docx"

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

function FormulaCell {
    param([string]$Formula)
    return @{ f = $Formula }
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
        return "<c r=""$ref""><f>$(Escape-Xml $Value["f"])</f></c>"
    }
    if ($Value -is [int] -or $Value -is [long] -or $Value -is [double] -or $Value -is [decimal]) {
        $num = ([double]$Value).ToString([System.Globalization.CultureInfo]::InvariantCulture)
        return "<c r=""$ref""><v>$num</v></c>"
    }
    return "<c r=""$ref"" t=""inlineStr""><is><t>$(Escape-Xml $Value)</t></is></c>"
}

function New-WorksheetXml {
    param([object[]]$Rows, [double[]]$Widths = @())
    $maxRows = [Math]::Max($Rows.Count, 1)
    $maxCols = 1
    foreach ($row in $Rows) { if ($row.Count -gt $maxCols) { $maxCols = $row.Count } }
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
    $dimension = "A1:$(Get-ColName $maxCols)$maxRows"
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

function Add-ZipEntry {
    param($Zip, [string]$EntryName, [string]$Content)
    $entry = $Zip.CreateEntry($EntryName)
    $stream = $entry.Open()
    $writer = [System.IO.StreamWriter]::new($stream, [System.Text.UTF8Encoding]::new($false))
    $writer.Write($Content)
    $writer.Dispose()
}

function ParamFormula {
    param([string]$Metric, [string]$ScenarioCell)
    return 'INDEX(Допущения!$C:$E,MATCH("' + $Metric + '",Допущения!$B:$B,0),MATCH(' + $ScenarioCell + ',Допущения!$C$3:$E$3,0))'
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

function New-Xlsx {
    param([string]$Path)

    $assumptionsText = @"
Финансовая модель OX - допущения||||||
Дата|2026-06-10|||||
Категория|Показатель|Осторожный сценарий|Базовый сценарий|Сильный сценарий|Единица|Источник / примечание
Экономика продукта|Доля призового фонда|0.80|0.80|0.80|% валидного оборота|ТЗ OX: призовой фонд и джекпот
Экономика продукта|Комиссия платформы|0.10|0.10|0.10|% валидного оборота|ТЗ OX: комиссия платформы
Экономика продукта|Взнос в следующий джекпот|0.10|0.10|0.10|% валидного оборота|ТЗ OX: взнос в следующий джекпот
Экономика продукта|Резерв газа от комиссии платформы|0.20|0.20|0.20|% комиссии платформы|ТЗ OX: резерв газа MVP
Экономика продукта|Чистая маржа до операционных расходов|0.08|0.08|0.08|% валидного оборота|Комиссия платформы минус резерв газа
Экономика продукта|Минимальный публичный джекпот|5000|5000|5000|USDC|ТЗ OX: минимальный джекпот MVP
Воронка|Стартовые визиты в месяц|10000|30000|80000|визиты|Гипотеза первого месяца запуска
Воронка|Месячный рост визитов|0.10|0.18|0.28|% месяц к месяцу|Сценарное допущение
Воронка|Доля доступных пользователей после гео/комплаенса|0.75|0.82|0.88|% визитов|После блокировок стран, VPN/proxy и комплаенса
Воронка|Конверсия в подключение кошелька|0.12|0.18|0.25|% доступных пользователей|UX/onboarding гипотеза
Воронка|Готовность к покупке за USDC|0.55|0.65|0.75|% подключенных кошельков|У пользователя есть путь к USDC
Воронка|Конверсия в первую покупку|0.25|0.32|0.40|% USDC-ready пользователей|Покупка первого билета
Воронка|Доля повторной покупки|0.30|0.42|0.55|% активных пользователей прошлого месяца|Повторное участие в тиражах
Воронка|Билетов на активного пользователя в месяц|1.40|2.20|3.10|билеты|Частота покупок
Воронка|Средний билет|8|15|25|USDC|Средняя итоговая цена билета
Партнерская экономика|Доля первых покупателей от партнеров|0.50|0.60|0.65|%|Доля новых покупателей с партнерской атрибуцией
Партнерская экономика|CPA за засчитанного игрока|15|15|15|USDC|ТЗ OX: CPA-гипотеза, не гарантия
Партнерская экономика|Доля подтвержденного CPA|0.65|0.75|0.82|%|После проверки мошенничества и качества трафика
Комплаенс|Доля пользователей с KYC|0.03|0.05|0.07|% активных пользователей|KYC по объему/риску
Комплаенс|Стоимость KYC на проверенного пользователя|2.50|2.00|1.80|USDC|Гипотеза провайдера
Переменные расходы|Поддержка на активного пользователя|0.30|0.25|0.20|USDC/месяц|Переменная нагрузка поддержки
Постоянные расходы|Продукт/разработка/операции в месяц|100000|140000|220000|USDC/месяц|Команда и операции
Постоянные расходы|Фиксированный маркетинг и мягкая локализация в месяц|15000|35000|80000|USDC/месяц|Контент, комьюнити, лист ожидания, исследование без продажи билетов
Постоянные расходы|Юридический и комплаенс-резерв в месяц|15000|25000|45000|USDC/месяц|Юристы, страны, лицензии, Латинская Америка и список наблюдения
Постоянные расходы|Оракул и спортивные данные в месяц|5000|8000|15000|USDC/месяц|API спортивных данных и проверка результатов
Постоянные расходы|Инфраструктура в месяц|4000|8000|20000|USDC/месяц|Хостинг, индексатор, мониторинг, бэкапы
Постоянные расходы|Аудит и безопасность в месяц|5000|7000|10000|USDC/месяц|Резерв на аудит и безопасность
Резерв риска|Пополнение джекпота в месяц|5000|8000|12000|USDC/месяц|Резерв поддержки публичного джекпота 5 000 USDC
Финансирование|Целевой runway|18|18|18|месяцы|Планирование финансирования
Финансирование|Стартовый денежный буфер|100000|150000|250000|USDC|Операционный запас
"@

    $countriesText = @"
Очередь|Страна / регион|Локализация|Статус запуска|Главные условия запуска|Цифровой / рыночный сигнал|Крипто / платежный сигнал|Основные каналы выхода на рынок|Источник / примечание
1 / денежный MVP|Нигерия|Английский сначала|Кандидат для первого юридического анализа и денежного MVP|Федеральная/штатная классификация ставок, тотализатора или лотереи; криптоплатежи; AML; реклама; налоги|DataReportal 2025: 107 млн пользователей интернета, 150 млн мобильных подключений|Chainalysis 2025: 6 место в мировом индексе принятия криптовалют|Футбольные медиа, Telegram/X, спортивные инфлюенсеры, партнеры, криптосообщества|https://datareportal.com/reports/digital-2025-nigeria; https://www.chainalysis.com/blog/2025-global-crypto-adoption-index/
1 / денежный MVP|Кения|Английский + суахили|Кандидат для первого юридического анализа и денежного MVP|GRA, Gambling Control Act 2025, онлайн-ставки, реклама, ответственная игра, криптоплатежи|DataReportal 2025: 27.4 млн пользователей интернета; мобильные подключения 121% населения|Нужна отдельная проверка USDC и платежей|Спортивные медиа, мобильные партнеры, футбольные сообщества, инфлюенсеры с учетом правил рекламы|https://datareportal.com/reports/digital-2025-kenya; https://gra.go.ke/about/
2 / практическое расширение|Гана|Английский|Кандидат второй волны после первой очереди|Лицензирование у регулятора азартных игр Ганы; AML/CFT; реклама; платежные правила; статус криптоплатежей|DataReportal 2025: 24.3 млн пользователей интернета; проникновение 69.9%|Нужна отдельная проверка криптоплатежей|Футбольные страницы, Facebook/YouTube, спортивные медиа, партнеры|https://datareportal.com/reports/digital-2025-ghana; https://www.gamingcommission.gov.gh/
2 / практическое расширение|Танзания|Суахили + английский|Кандидат второй волны после первой очереди|Регулятор азартных игр Танзании; онлайн-продукт; платежи; KYC; реклама|DataReportal 2025: 79 млн мобильных подключений; 20.2 млн пользователей интернета|Нужна отдельная проверка криптоплатежей|Суахили-спортивные сообщества, локальные партнеры, футбольные медиа|https://datareportal.com/reports/digital-2025-tanzania; https://www.gamingboard.go.tz/
2 / практическое расширение|Уганда|Английский|Кандидат второй волны после Кении/Танзании|NLGRB, ответственная игра, реклама, платежи, KYC, онлайн-разрешения|DataReportal 2025: 38.6 млн мобильных подключений; 14.2 млн пользователей интернета|Нужна отдельная проверка криптоплатежей|Спортивные сообщества, региональные партнеры, кампании ответственной игры|https://datareportal.com/reports/digital-2025-uganda; https://lgrb.go.ug/
2 / практическое расширение|Замбия|Английский|Кандидат второй волны как малый тест экономики|Лицензии, налоги, реклама, криптоплатежи, AML|DataReportal 2025: 19.9 млн мобильных подключений; 7.13 млн пользователей интернета|Нужна отдельная проверка криптоплатежей|Точечные партнерские тесты, спортивные медиа, малобюджетные когорты|https://datareportal.com/reports/digital-2025-zambia
2 / кандидат Латинской Америки|Перу|Испанский|Кандидат второй волны; выручка только после юридического разрешения|Регулируемый маршрут через MINCETUR; лицензия/разрешение; KYC/AML; реклама; платежи; проверка USDC|Регулируемый рынок Латинской Америки, футбол, испанский язык|USDC и криптоплатежи требуют отдельной проверки|Спортивные медиа, футбольные сообщества, партнеры после юридического разрешения|https://www.gob.pe/mincetur
2 / кандидат Латинской Америки|Колумбия|Испанский|Кандидат второй волны; выручка только после юридического разрешения|Разрешение Coljuegos; правила игр; KYC/AML; платежи; реклама|Более зрелый регулируемый онлайн-рынок Латинской Америки; футбол|USDC требует отдельной проверки|Локальные спортивные медиа и партнеры после разрешенного маршрута|https://www.coljuegos.gov.co/
3 / стратегическое наблюдение|Бразилия|Португальский|Мягкая локализация без продажи билетов; денежный запуск только после разрешенной структуры|Локальная авторизация; .bet.br; юридическое лицо; защита потребителя; реклама; платежи; вероятные ограничения криптоплатежей|Огромный футбольный и цифровой рынок|Chainalysis 2025: 5 место; законность USDC-платежей нужно подтвердить|Португальский контент, лист ожидания, B2B-партнерства, юридическая подготовка|https://www.gov.br/fazenda/pt-br/composicao/orgaos/secretaria-de-premios-e-apostas
3 / стратегическое наблюдение|Мексика|Испанский|Мягкая локализация без продажи билетов; денежный запуск после подтверждения юридического маршрута|Лицензирование, реклама, налоги, платежи, KYC/AML|Крупный рынок Латинской Америки, футбол, цифровая аудитория|Нужна отдельная проверка криптоплатежей|Контент, партнерские переговоры, лист ожидания без депозита|Требуется отдельная проверка
3 / стратегическое наблюдение|Филиппины|Английский/филиппинский|Мягкая локализация без продажи билетов|PAGCOR/локальный режим; репутационная проверка после изменений вокруг офшорных игровых операторов; реклама; платежи|Английский язык, спортивная и игровая аудитория|Нужна юридическая, репутационная и криптоплатежная проверка|Исследование, контент, партнеры без продажи билетов|Внутренняя аналитика OX
3 / малое web3-исследование|Грузия|Грузинский/английский/русский|Только исследование и лист ожидания до юридического допуска|Проверка статуса тотализатора, рекламы, платежей и лицензии|Компактный рынок для web3-исследования|Высокая криптоактивность по данным, скорректированным на численность населения|Web3/футбольное сообщество, интервью, лист ожидания|Chainalysis 2025, данные с поправкой на численность населения
3 / малое web3-исследование|Армения|Армянский/русский/английский|Только исследование и лист ожидания до юридического допуска|Проверка ставок, рекламы, платежей и ограничений азартных игр|Компактный рынок, русскоязычный/англоязычный мост|Нужна отдельная проверка криптоплатежей|Низкобюджетное исследование сообщества|Chainalysis 2025, данные с поправкой на численность населения
3 / малое web3-исследование|Молдова|Румынский/русский|Только исследование и лист ожидания до юридического допуска|Проверка режима азартных игр, рекламы и платежей|Небольшой рынок для теста языка и спроса|Высокая криптоактивность по данным, скорректированным на численность населения|Исследование, интервью, лист ожидания|Chainalysis 2025, данные с поправкой на численность населения
3 / исследование Латинской Америки|Парагвай|Испанский|Только исследование и партнерские переговоры до юридического допуска|Низкая предсказуемость регулирования и платежей|Футбол, потенциально дешевый трафик|Нужна отдельная проверка криптоплатежей|Контент и партнерские разговоры без продажи билетов|Требуется отдельная проверка
3 / исследование Латинской Америки|Доминиканская Республика|Испанский|Только исследование и партнерские переговоры до юридического допуска|Правила азартных игр, реклама, платежи, KYC/AML|Спорт, туризм, платежеспособные сегменты|Нужна отдельная проверка криптоплатежей|Контент и локальные партнерства без билетов|Требуется отдельная проверка
Только исследование без выручки|Индия|Английский/хинди|Без продажи билетов, без CPA за покупателя, без депозита|Денежные онлайн-игры, реклама и финансовое содействие несут высокий риск; нужен отдельный юридический маршрут|Огромная спортивная аудитория|Chainalysis 2025: 1 место, но денежный запуск рискован|Образовательный контент, лист ожидания, бесплатные прогнозы без денежного приза|https://prsindia.org/billtrack/the-promotion-and-regulation-of-online-gaming-bill-2025
Только исследование без выручки|Малайзия|Английский/малайский|Без продажи билетов, без CPA за покупателя, без депозита|Ограничения ставок/азартных игр, религиозный и репутационный фактор, риск онлайн-игр|Цифровая аудитория, футбол, мобильность|Нужна юридическая и платежная проверка; не считать рынком выручки|Нейтральное исследование, лист ожидания, без обещаний выигрыша|Common Gaming Houses Act 1953; Betting Act 1953
Только исследование без выручки|Индонезия, Вьетнам, Таиланд, Пакистан, Бангладеш, Турция|Локальные языки|Без денежного MVP|Высокий риск запрета, рекламы, платежей или классификации как азартной игры|Аудитория может быть большой|Не считать источником выручки до отдельного юридического маршрута|Исследование без депозита и без денежного приза|Внутренняя аналитика OX
Красная зона|США, Канада, Великобритания, ЕС/ЕЭЗ, Австралия, Китай, Россия/Беларусь, санкционные территории|Не применимо|Заблокировано для MVP|Нет таргетинга и покупки билетов без отдельной лицензии/решения|Высокий regulatory/sanctions/advertising risk|Не подходит для MVP|Маркетинг и денежный продукт запрещены до отдельного решения|Внутреннее ТЗ OX
"@

    $assumptions = Convert-PipeTable $assumptionsText @(3,4,5)
    $countryRows = Convert-PipeTable $countriesText @()

    function Build-FunnelRows {
        $rows = @()
        $rows += ,@("Месяц", "Сценарий", "Активных стран", "Визиты", "Доступные пользователи", "Подключили кошелек", "Готовы к USDC", "Первые покупатели", "Повторные покупатели", "Активные платящие пользователи")
        foreach ($scenario in @("Осторожный сценарий", "Базовый сценарий", "Сильный сценарий")) {
            for ($month = 1; $month -le 36; $month++) {
                $r = $rows.Count + 1
                $prevActive = if ($month -eq 1) { "0" } else { "J$($r - 1)" }
                $rows += ,@(
                    $month,
                    $scenario,
                    (FormulaCell "IF(A$r<7,1,IF(A$r<13,2,IF(A$r<24,3,4)))"),
                    (FormulaCell "$(ParamFormula 'Стартовые визиты в месяц' "B$r")*POWER(1+$(ParamFormula 'Месячный рост визитов' "B$r"),A$r-1)*C$r"),
                    (FormulaCell "D$r*$(ParamFormula 'Доля доступных пользователей после гео/комплаенса' "B$r")"),
                    (FormulaCell "E$r*$(ParamFormula 'Конверсия в подключение кошелька' "B$r")"),
                    (FormulaCell "F$r*$(ParamFormula 'Готовность к покупке за USDC' "B$r")"),
                    (FormulaCell "G$r*$(ParamFormula 'Конверсия в первую покупку' "B$r")"),
                    (FormulaCell "$prevActive*$(ParamFormula 'Доля повторной покупки' "B$r")"),
                    (FormulaCell "H$r+I$r")
                )
            }
        }
        return $rows
    }

    function Build-RevenueRows {
        $rows = @()
        $rows += ,@("Месяц", "Сценарий", "Активные пользователи", "Продано билетов", "Средний билет", "Оборот", "Призовой фонд", "Комиссия платформы", "Взнос в джекпот", "Резерв газа", "Чистая выручка до расходов")
        foreach ($scenario in @("Осторожный сценарий", "Базовый сценарий", "Сильный сценарий")) {
            for ($month = 1; $month -le 36; $month++) {
                $r = $rows.Count + 1
                $rows += ,@(
                    $month,
                    $scenario,
                    (FormulaCell "SUMIFS(Воронка!`$J:`$J,Воронка!`$A:`$A,A$r,Воронка!`$B:`$B,B$r)"),
                    (FormulaCell "C$r*$(ParamFormula 'Билетов на активного пользователя в месяц' "B$r")"),
                    (FormulaCell "$(ParamFormula 'Средний билет' "B$r")"),
                    (FormulaCell "D$r*E$r"),
                    (FormulaCell "F$r*$(ParamFormula 'Доля призового фонда' "B$r")"),
                    (FormulaCell "F$r*$(ParamFormula 'Комиссия платформы' "B$r")"),
                    (FormulaCell "F$r*$(ParamFormula 'Взнос в следующий джекпот' "B$r")"),
                    (FormulaCell "H$r*$(ParamFormula 'Резерв газа от комиссии платформы' "B$r")"),
                    (FormulaCell "H$r-J$r")
                )
            }
        }
        return $rows
    }

    function Build-CostRows {
        $rows = @()
        $rows += ,@("Месяц", "Сценарий", "Первые покупатели", "Активные пользователи", "CPA-расход", "Фиксированный маркетинг", "KYC-расход", "Поддержка", "Продукт/разработка/операции", "Юристы/комплаенс", "Оракул/данные", "Инфраструктура", "Аудит/безопасность", "Пополнение джекпота", "Всего расходов")
        foreach ($scenario in @("Осторожный сценарий", "Базовый сценарий", "Сильный сценарий")) {
            for ($month = 1; $month -le 36; $month++) {
                $r = $rows.Count + 1
                $rows += ,@(
                    $month,
                    $scenario,
                    (FormulaCell "SUMIFS(Воронка!`$H:`$H,Воронка!`$A:`$A,A$r,Воронка!`$B:`$B,B$r)"),
                    (FormulaCell "SUMIFS(Воронка!`$J:`$J,Воронка!`$A:`$A,A$r,Воронка!`$B:`$B,B$r)"),
                    (FormulaCell "C$r*$(ParamFormula 'Доля первых покупателей от партнеров' "B$r")*$(ParamFormula 'CPA за засчитанного игрока' "B$r")*$(ParamFormula 'Доля подтвержденного CPA' "B$r")"),
                    (FormulaCell "$(ParamFormula 'Фиксированный маркетинг и мягкая локализация в месяц' "B$r")"),
                    (FormulaCell "D$r*$(ParamFormula 'Доля пользователей с KYC' "B$r")*$(ParamFormula 'Стоимость KYC на проверенного пользователя' "B$r")"),
                    (FormulaCell "D$r*$(ParamFormula 'Поддержка на активного пользователя' "B$r")"),
                    (FormulaCell "$(ParamFormula 'Продукт/разработка/операции в месяц' "B$r")"),
                    (FormulaCell "$(ParamFormula 'Юридический и комплаенс-резерв в месяц' "B$r")"),
                    (FormulaCell "$(ParamFormula 'Оракул и спортивные данные в месяц' "B$r")"),
                    (FormulaCell "$(ParamFormula 'Инфраструктура в месяц' "B$r")"),
                    (FormulaCell "$(ParamFormula 'Аудит и безопасность в месяц' "B$r")"),
                    (FormulaCell "$(ParamFormula 'Пополнение джекпота в месяц' "B$r")"),
                    (FormulaCell "SUM(E$r:N$r)")
                )
            }
        }
        return $rows
    }

    function Build-UnitRows {
        $rows = @()
        $rows += ,@("Месяц", "Сценарий", "Оборот", "Чистая выручка", "Всего расходов", "Первые покупатели", "Активные пользователи", "CAC", "ARPPU", "Выручка на активного пользователя", "Contribution margin", "Окупаемость, месяцев", "Оборот для безубыточности")
        foreach ($scenario in @("Осторожный сценарий", "Базовый сценарий", "Сильный сценарий")) {
            for ($month = 1; $month -le 36; $month++) {
                $r = $rows.Count + 1
                $rows += ,@(
                    $month,
                    $scenario,
                    (FormulaCell "SUMIFS(Выручка!`$F:`$F,Выручка!`$A:`$A,A$r,Выручка!`$B:`$B,B$r)"),
                    (FormulaCell "SUMIFS(Выручка!`$K:`$K,Выручка!`$A:`$A,A$r,Выручка!`$B:`$B,B$r)"),
                    (FormulaCell "SUMIFS(Расходы!`$O:`$O,Расходы!`$A:`$A,A$r,Расходы!`$B:`$B,B$r)"),
                    (FormulaCell "SUMIFS(Расходы!`$C:`$C,Расходы!`$A:`$A,A$r,Расходы!`$B:`$B,B$r)"),
                    (FormulaCell "SUMIFS(Расходы!`$D:`$D,Расходы!`$A:`$A,A$r,Расходы!`$B:`$B,B$r)"),
                    (FormulaCell "IF(F$r=0,0,(SUMIFS(Расходы!`$E:`$E,Расходы!`$A:`$A,A$r,Расходы!`$B:`$B,B$r)+SUMIFS(Расходы!`$F:`$F,Расходы!`$A:`$A,A$r,Расходы!`$B:`$B,B$r))/F$r)"),
                    (FormulaCell "IF(G$r=0,0,C$r/G$r)"),
                    (FormulaCell "IF(G$r=0,0,D$r/G$r)"),
                    (FormulaCell "D$r-E$r"),
                    (FormulaCell "IF(J$r<=0,0,H$r/J$r)"),
                    (FormulaCell "IF($(ParamFormula 'Чистая маржа до операционных расходов' "B$r")=0,0,E$r/$(ParamFormula 'Чистая маржа до операционных расходов' "B$r"))")
                )
            }
        }
        return $rows
    }

    $scenarioRows = @()
    $scenarioRows += ,@("Показатель", "Осторожный сценарий", "Базовый сценарий", "Сильный сценарий", "Комментарий")
    $scenarioRows += ,@("Оборот за 12 месяцев", (FormulaCell 'SUMIFS(Выручка!$F:$F,Выручка!$B:$B,B$1,Выручка!$A:$A,"<=12")'), (FormulaCell 'SUMIFS(Выручка!$F:$F,Выручка!$B:$B,C$1,Выручка!$A:$A,"<=12")'), (FormulaCell 'SUMIFS(Выручка!$F:$F,Выручка!$B:$B,D$1,Выручка!$A:$A,"<=12")'), "Валидный оборот билетов")
    $scenarioRows += ,@("Чистая выручка за 12 месяцев", (FormulaCell 'SUMIFS(Выручка!$K:$K,Выручка!$B:$B,B$1,Выручка!$A:$A,"<=12")'), (FormulaCell 'SUMIFS(Выручка!$K:$K,Выручка!$B:$B,C$1,Выручка!$A:$A,"<=12")'), (FormulaCell 'SUMIFS(Выручка!$K:$K,Выручка!$B:$B,D$1,Выручка!$A:$A,"<=12")'), "Комиссия платформы минус резерв газа")
    $scenarioRows += ,@("Расходы за 12 месяцев", (FormulaCell 'SUMIFS(Расходы!$O:$O,Расходы!$B:$B,B$1,Расходы!$A:$A,"<=12")'), (FormulaCell 'SUMIFS(Расходы!$O:$O,Расходы!$B:$B,C$1,Расходы!$A:$A,"<=12")'), (FormulaCell 'SUMIFS(Расходы!$O:$O,Расходы!$B:$B,D$1,Расходы!$A:$A,"<=12")'), "Операционные и переменные расходы")
    $scenarioRows += ,@("Оборот за 24 месяца", (FormulaCell 'SUMIFS(Выручка!$F:$F,Выручка!$B:$B,B$1,Выручка!$A:$A,"<=24")'), (FormulaCell 'SUMIFS(Выручка!$F:$F,Выручка!$B:$B,C$1,Выручка!$A:$A,"<=24")'), (FormulaCell 'SUMIFS(Выручка!$F:$F,Выручка!$B:$B,D$1,Выручка!$A:$A,"<=24")'), "Валидный оборот билетов")
    $scenarioRows += ,@("Чистая выручка за 24 месяца", (FormulaCell 'SUMIFS(Выручка!$K:$K,Выручка!$B:$B,B$1,Выручка!$A:$A,"<=24")'), (FormulaCell 'SUMIFS(Выручка!$K:$K,Выручка!$B:$B,C$1,Выручка!$A:$A,"<=24")'), (FormulaCell 'SUMIFS(Выручка!$K:$K,Выручка!$B:$B,D$1,Выручка!$A:$A,"<=24")'), "Комиссия платформы минус резерв газа")
    $scenarioRows += ,@("Расходы за 24 месяца", (FormulaCell 'SUMIFS(Расходы!$O:$O,Расходы!$B:$B,B$1,Расходы!$A:$A,"<=24")'), (FormulaCell 'SUMIFS(Расходы!$O:$O,Расходы!$B:$B,C$1,Расходы!$A:$A,"<=24")'), (FormulaCell 'SUMIFS(Расходы!$O:$O,Расходы!$B:$B,D$1,Расходы!$A:$A,"<=24")'), "Операционные и переменные расходы")
    $scenarioRows += ,@("Оборот за 36 месяцев", (FormulaCell 'SUMIFS(Выручка!$F:$F,Выручка!$B:$B,B$1)'), (FormulaCell 'SUMIFS(Выручка!$F:$F,Выручка!$B:$B,C$1)'), (FormulaCell 'SUMIFS(Выручка!$F:$F,Выручка!$B:$B,D$1)'), "Валидный оборот билетов")
    $scenarioRows += ,@("Чистая выручка за 36 месяцев", (FormulaCell 'SUMIFS(Выручка!$K:$K,Выручка!$B:$B,B$1)'), (FormulaCell 'SUMIFS(Выручка!$K:$K,Выручка!$B:$B,C$1)'), (FormulaCell 'SUMIFS(Выручка!$K:$K,Выручка!$B:$B,D$1)'), "Комиссия платформы минус резерв газа")
    $scenarioRows += ,@("Расходы за 36 месяцев", (FormulaCell 'SUMIFS(Расходы!$O:$O,Расходы!$B:$B,B$1)'), (FormulaCell 'SUMIFS(Расходы!$O:$O,Расходы!$B:$B,C$1)'), (FormulaCell 'SUMIFS(Расходы!$O:$O,Расходы!$B:$B,D$1)'), "Операционные и переменные расходы")
    $scenarioRows += ,@("Описание сценария", "Медленная юридическая проверка, высокий CAC, низкое удержание; выручка только из одной разрешенной страны", "Контролируемый денежный запуск Нигерия/Кения, затем выборочные страны 2 очереди; Латинская Америка и список наблюдения сначала без выручки", "Быстрый партнерский рост в разрешенных странах, плюс мягкая локализация Латинской Америки без приема денег до юридического разрешения", "Описание")

    $sensitivityRows = @(
        @("Переменная", "Негативный вариант", "База", "Сильный вариант", "Смысл"),
        @("CPA за засчитанного игрока", 25, 15, 10, "Чем выше CPA, тем хуже CAC и окупаемость"),
        @("Средний билет", 8, 15, 25, "Низкий билет требует больше пользователей для того же оборота"),
        @("Доля повторной покупки", 0.25, 0.42, 0.60, "Удержание - главный драйвер LTV"),
        @("Конверсия в первую покупку", 0.20, 0.32, 0.45, "Проверяет качество UX и onboarding"),
        @("Чистая маржа до операционных расходов", 0.06, 0.08, 0.09, "Чувствительность к gas reserve и комиссии"),
        @("Постоянные расходы в месяц", 220000, 180000, 140000, "Lean-операции снижают оборот безубыточности"),
        @("Оборот безубыточности", (FormulaCell "B7/B6"), (FormulaCell "C7/C6"), (FormulaCell "D7/D6"), "Постоянные расходы / чистая маржа"),
        @("Стресс-тест: CPA +50%", (FormulaCell "Допущения!D20*1.5"), "", "", "Проверка роста стоимости привлечения"),
        @("Стресс-тест: средний билет -30%", (FormulaCell "Допущения!D18*0.7"), "", "", "Проверка слабой монетизации"),
        @("Стресс-тест: удержание -50%", (FormulaCell "Допущения!D16*0.5"), "", "", "Проверка слабой повторяемости")
    )

    $summaryRows = @()
    $summaryRows += ,@("Сценарий", "Оборот 12М", "Чистая выручка 12М", "Расходы 12М", "Потребность 12М", "Оборот 24М", "Чистая выручка 24М", "Расходы 24М", "Оборот 36М", "Чистая выручка 36М", "Расходы 36М", "Средний оборот безубыточности", "Потребность в финансировании на 18М")
    foreach ($scenario in @("Осторожный сценарий", "Базовый сценарий", "Сильный сценарий")) {
        $r = $summaryRows.Count + 1
        $summaryRows += ,@(
            $scenario,
            (FormulaCell "SUMIFS(Выручка!`$F:`$F,Выручка!`$B:`$B,A$r,Выручка!`$A:`$A,""<=12"")"),
            (FormulaCell "SUMIFS(Выручка!`$K:`$K,Выручка!`$B:`$B,A$r,Выручка!`$A:`$A,""<=12"")"),
            (FormulaCell "SUMIFS(Расходы!`$O:`$O,Расходы!`$B:`$B,A$r,Расходы!`$A:`$A,""<=12"")"),
            (FormulaCell "MAX(0,D$r-C$r)"),
            (FormulaCell "SUMIFS(Выручка!`$F:`$F,Выручка!`$B:`$B,A$r,Выручка!`$A:`$A,""<=24"")"),
            (FormulaCell "SUMIFS(Выручка!`$K:`$K,Выручка!`$B:`$B,A$r,Выручка!`$A:`$A,""<=24"")"),
            (FormulaCell "SUMIFS(Расходы!`$O:`$O,Расходы!`$B:`$B,A$r,Расходы!`$A:`$A,""<=24"")"),
            (FormulaCell "SUMIFS(Выручка!`$F:`$F,Выручка!`$B:`$B,A$r)"),
            (FormulaCell "SUMIFS(Выручка!`$K:`$K,Выручка!`$B:`$B,A$r)"),
            (FormulaCell "SUMIFS(Расходы!`$O:`$O,Расходы!`$B:`$B,A$r)"),
            (FormulaCell "AVERAGEIFS(Юнит_экономика!`$M:`$M,Юнит_экономика!`$B:`$B,A$r,Юнит_экономика!`$A:`$A,""<=12"")"),
            (FormulaCell "MAX(0,SUMIFS(Расходы!`$O:`$O,Расходы!`$B:`$B,A$r,Расходы!`$A:`$A,""<=18"")-SUMIFS(Выручка!`$K:`$K,Выручка!`$B:`$B,A$r,Выручка!`$A:`$A,""<=18""))+INDEX(Допущения!`$C:`$E,MATCH(""Стартовый денежный буфер"",Допущения!`$B:`$B,0),MATCH(A$r,Допущения!`$C`$3:`$E`$3,0))")
        )
    }
    $summaryRows += ,@("Примечание", "Потребность в финансировании - расчетная оценка, не финальный fundraising ask", "", "", "", "", "", "", "", "", "", "", "Нужна проверка бюджета команды, юристов и лицензий")

    $sheets = @(
        @{ Name = "Допущения"; Rows = $assumptions; Widths = @(24,42,20,20,20,18,50) },
        @{ Name = "Страны"; Rows = $countryRows; Widths = @(16,26,24,28,56,48,44,44,66) },
        @{ Name = "Воронка"; Rows = (Build-FunnelRows); Widths = @(10,22,16,16,22,22,18,18,20,28) },
        @{ Name = "Выручка"; Rows = (Build-RevenueRows); Widths = @(10,22,22,18,18,18,18,22,20,16,28) },
        @{ Name = "Расходы"; Rows = (Build-CostRows); Widths = @(10,22,20,22,18,22,18,18,28,22,18,18,22,22,18) },
        @{ Name = "Юнит_экономика"; Rows = (Build-UnitRows); Widths = @(10,22,18,20,18,20,22,14,14,30,22,22,28) },
        @{ Name = "Сценарии"; Rows = $scenarioRows; Widths = @(34,24,24,24,48) },
        @{ Name = "Чувствительность"; Rows = $sensitivityRows; Widths = @(40,20,18,20,52) },
        @{ Name = "Сводка"; Rows = $summaryRows; Widths = @(24,18,22,18,18,18,22,18,18,22,18,30,34) }
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
  <dc:title>Финансовая модель OX</dc:title>
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

    $fileStream = [System.IO.File]::Open($Path, [System.IO.FileMode]::Create, [System.IO.FileAccess]::ReadWrite)
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
}

function Convert-MarkdownToRussian {
    $text = Get-Content -LiteralPath $SourceMd -Encoding UTF8 -Raw
    $replacements = [ordered]@{
        "Executive Summary" = "Резюме для инвестора"
        "on-chain sports express platform" = "блокчейн-платформа спортивных экспрессов"
        "pari-mutuel" = "модель тотализатора"
        "Post-MVP" = "После MVP"
        "risk/compliance layer" = "слой риска и комплаенса"
        "frontend" = "пользовательский интерфейс"
        "backend" = "серверная часть"
        "smart contracts" = "смарт-контракты"
        "oracle" = "оракул"
        "settlement engine" = "модуль расчета итогов"
        "relayer" = "служба отправки транзакций"
        "admin panel" = "админ-панель"
        "analytics" = "аналитика"
        "risk control" = "контроль рисков"
        "manual fallback claim" = "ручное резервное получение выплаты"
        "ticket" = "билет"
        "tickets" = "билеты"
        "wallet" = "кошелек"
        "wallets" = "кошельки"
        "onboarding" = "первичный вход пользователя"
        "launch gate" = "условие запуска"
        "launch gates" = "условия запуска"
        "watchlist" = "список наблюдения"
        "red zone" = "красная зона"
        "Go-to-market" = "Выход на рынок"
        "GTM" = "выход на рынок"
        "Unit economics" = "Юнит-экономика"
        "Stress tests" = "Стресс-тесты"
        "Stress test" = "Стресс-тест"
        "Break-even" = "Безубыточность"
        "Funding" = "Финансирование"
        "runway" = "запас времени до исчерпания бюджета"
        "mainnet" = "основная сеть"
        "testnet" = "тестовая сеть"
        "source" = "источник"
        "source / note" = "источник / примечание"
        "Digital signal" = "Цифровой сигнал"
        "Crypto signal" = "Крипто-сигнал"
        "marketing" = "маркетинг"
        "support" = "поддержка"
        "fraud" = "мошенничество"
        "legal" = "юридический"
        "compliance" = "комплаенс"
        "payment" = "платеж"
        "payments" = "платежи"
        "country" = "страна"
        "countries" = "страны"
        "user" = "пользователь"
        "users" = "пользователи"
        "partner" = "партнер"
        "partners" = "партнеры"
        "affiliate" = "партнерский"
        "affiliate partners" = "партнеры"
        "sports media" = "спортивные медиа"
        "football" = "футбол"
        "mobile-first" = "ориентация на мобильный сценарий"
        "crypto-native" = "крипто-ориентированный"
        "high-value" = "крупный"
        "Contribution margin" = "Маржинальность после переменных расходов"
        "gross ticket volume / GMV" = "валовый оборот билетов"
        "net platform revenue" = "чистая выручка платформы"
        "platform fee" = "комиссия платформы"
        "Prize Pool" = "Призовой фонд"
        "Jackpot Contribution" = "Взнос в джекпот"
        "Gas Reserve" = "Резерв газа"
        "jackpot top-up" = "пополнение джекпота"
        "top-up" = "пополнение"
        "refunds" = "возвраты"
        "voided draw" = "отмененный тираж"
        "KPI" = "ключевой показатель"
        "milestones" = "контрольные этапы"
        "go/no-go" = "решение запускать / не запускать"
        "No-go" = "Запрет запуска"
        "Go" = "Разрешение на масштабирование"
        "quality checklist" = "контрольный список качества"
        "quality" = "качество"
        "DataReportal" = "DataReportal"
        "Chainalysis" = "Chainalysis"
        "Base" = "Base"
        "USDC" = "USDC"
        "KYC/AML" = "KYC/AML"
        "PWA" = "PWA"
        "CPA" = "CPA"
        "RevShare" = "RevShare"
    }
    foreach ($key in $replacements.Keys) {
        $text = $text.Replace($key, $replacements[$key])
    }
    $text = $text.Replace("OX: анализ потенциальных пользователей, стран локализации и финансовой модели", "OX: анализ потенциальных пользователей, стран локализации и финансовой модели")
    $text = $text.Replace("working investor document", "рабочий инвесторский документ")
    Set-Content -LiteralPath $RuMd -Encoding UTF8 -Value $text
}

function New-DocxFromMarkdown {
    param([string]$MarkdownPath, [string]$DocxPath)
    $lines = Get-Content -LiteralPath $MarkdownPath -Encoding UTF8
    $bodyParts = @()
    $inCode = $false
    $i = 0
    while ($i -lt $lines.Count) {
        $line = $lines[$i]
        if ($line.Trim() -eq "---") { $i++; continue }
        if ($line.Trim().StartsWith('```')) {
            $inCode = -not $inCode
            $i++
            continue
        }
        if ($inCode) {
            $bodyParts += New-WordParagraph $line "Code"
            $i++
            continue
        }
        if ($line.Trim().StartsWith("|") -and ($i + 1) -lt $lines.Count -and $lines[$i + 1].Trim().StartsWith("|---")) {
            $tableLines = @($line)
            $i += 2
            while ($i -lt $lines.Count -and $lines[$i].Trim().StartsWith("|")) {
                $tableLines += $lines[$i]
                $i++
            }
            $bodyParts += New-WordTable $tableLines
            continue
        }
        if ($line -match "^(#{1,6})\s+(.+)$") {
            $level = $Matches[1].Length
            $bodyParts += New-WordParagraph $Matches[2] "Heading$level"
        } elseif ($line.Trim().StartsWith("- ")) {
            $bodyParts += New-WordParagraph ($line.Trim().Substring(2)) "Bullet"
        } elseif ($line.Trim().StartsWith("> ")) {
            $bodyParts += New-WordParagraph ($line.Trim().Substring(2)) "Quote"
        } elseif ($line.Trim() -eq "") {
            $bodyParts += "<w:p/>"
        } else {
            $bodyParts += New-WordParagraph $line "Normal"
        }
        $i++
    }
    $documentXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    $($bodyParts -join "`n")
    <w:sectPr><w:pgSz w:w="11906" w:h="16838"/><w:pgMar w:top="1134" w:right="1134" w:bottom="1134" w:left="1134" w:header="708" w:footer="708" w:gutter="0"/></w:sectPr>
  </w:body>
</w:document>
"@
    $contentTypes = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
  <Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
  <Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
  <Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>
</Types>
"@
    $rootRels = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>
</Relationships>
"@
    $docRels = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
</Relationships>
"@
    $stylesXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:style w:type="paragraph" w:default="1" w:styleId="Normal"><w:name w:val="Normal"/><w:rPr><w:rFonts w:ascii="Calibri" w:hAnsi="Calibri" w:cs="Calibri"/><w:sz w:val="22"/></w:rPr></w:style>
  <w:style w:type="paragraph" w:styleId="Heading1"><w:name w:val="heading 1"/><w:basedOn w:val="Normal"/><w:pPr><w:spacing w:before="360" w:after="180"/></w:pPr><w:rPr><w:b/><w:sz w:val="32"/></w:rPr></w:style>
  <w:style w:type="paragraph" w:styleId="Heading2"><w:name w:val="heading 2"/><w:basedOn w:val="Normal"/><w:pPr><w:spacing w:before="300" w:after="120"/></w:pPr><w:rPr><w:b/><w:sz w:val="28"/></w:rPr></w:style>
  <w:style w:type="paragraph" w:styleId="Heading3"><w:name w:val="heading 3"/><w:basedOn w:val="Normal"/><w:pPr><w:spacing w:before="240" w:after="100"/></w:pPr><w:rPr><w:b/><w:sz w:val="24"/></w:rPr></w:style>
  <w:style w:type="paragraph" w:styleId="Heading4"><w:name w:val="heading 4"/><w:basedOn w:val="Normal"/><w:pPr><w:spacing w:before="180" w:after="80"/></w:pPr><w:rPr><w:b/><w:sz w:val="22"/></w:rPr></w:style>
  <w:style w:type="paragraph" w:styleId="Bullet"><w:name w:val="Bullet"/><w:basedOn w:val="Normal"/><w:pPr><w:ind w:left="720" w:hanging="360"/></w:pPr></w:style>
  <w:style w:type="paragraph" w:styleId="Code"><w:name w:val="Code"/><w:basedOn w:val="Normal"/><w:rPr><w:rFonts w:ascii="Consolas" w:hAnsi="Consolas"/><w:sz w:val="20"/></w:rPr></w:style>
  <w:style w:type="paragraph" w:styleId="Quote"><w:name w:val="Quote"/><w:basedOn w:val="Normal"/><w:pPr><w:ind w:left="360"/></w:pPr><w:rPr><w:i/></w:rPr></w:style>
</w:styles>
"@
    $coreXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <dc:title>OX: анализ пользователей, стран и финансовой модели</dc:title>
  <dc:creator>Codex</dc:creator>
  <cp:lastModifiedBy>Codex</cp:lastModifiedBy>
  <dcterms:created xsi:type="dcterms:W3CDTF">2026-06-10T12:00:00Z</dcterms:created>
  <dcterms:modified xsi:type="dcterms:W3CDTF">2026-06-10T12:00:00Z</dcterms:modified>
</cp:coreProperties>
"@
    $appXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties"><Application>Microsoft Word</Application><Company>OX</Company></Properties>
"@
    $fs = [System.IO.File]::Open($DocxPath, [System.IO.FileMode]::Create, [System.IO.FileAccess]::ReadWrite)
    try {
        $zip = [System.IO.Compression.ZipArchive]::new($fs, [System.IO.Compression.ZipArchiveMode]::Create, $true)
        try {
            Add-ZipEntry $zip "[Content_Types].xml" $contentTypes
            Add-ZipEntry $zip "_rels/.rels" $rootRels
            Add-ZipEntry $zip "word/_rels/document.xml.rels" $docRels
            Add-ZipEntry $zip "word/document.xml" $documentXml
            Add-ZipEntry $zip "word/styles.xml" $stylesXml
            Add-ZipEntry $zip "docProps/core.xml" $coreXml
            Add-ZipEntry $zip "docProps/app.xml" $appXml
        } finally {
            $zip.Dispose()
        }
    } finally {
        $fs.Dispose()
    }
}

function New-WordParagraph {
    param([string]$Text, [string]$Style)
    $styleXml = if ($Style -ne "Normal") { "<w:pPr><w:pStyle w:val=""$Style""/></w:pPr>" } else { "" }
    $prefix = if ($Style -eq "Bullet") { "• " } else { "" }
    return "<w:p>$styleXml<w:r><w:t xml:space=""preserve"">$(Escape-Xml ($prefix + $Text))</w:t></w:r></w:p>"
}

function New-WordTable {
    param([string[]]$Lines)
    $rowsXml = @()
    foreach ($line in $Lines) {
        $cells = ($line.Trim().Trim("|") -split "\|") | ForEach-Object { $_.Trim() }
        $cellXml = @()
        foreach ($cell in $cells) {
            $cellXml += "<w:tc><w:tcPr><w:tcW w:w=""2400"" w:type=""dxa""/></w:tcPr><w:p><w:r><w:t>$(Escape-Xml $cell)</w:t></w:r></w:p></w:tc>"
        }
        $rowsXml += "<w:tr>$($cellXml -join '')</w:tr>"
    }
    return "<w:tbl><w:tblPr><w:tblBorders><w:top w:val=""single"" w:sz=""4""/><w:left w:val=""single"" w:sz=""4""/><w:bottom w:val=""single"" w:sz=""4""/><w:right w:val=""single"" w:sz=""4""/><w:insideH w:val=""single"" w:sz=""4""/><w:insideV w:val=""single"" w:sz=""4""/></w:tblBorders></w:tblPr>$($rowsXml -join '')</w:tbl>"
}

# Markdown-файл является основным русским исходником и не должен
# перезаписываться машинной заменой терминов.
try {
    New-DocxFromMarkdown $DeepAnalyticsMd $DeepAnalyticsDocx
} catch {
    Write-Warning "Word-документ глубокой аналитики не обновлен: $($_.Exception.Message)"
    New-DocxFromMarkdown $DeepAnalyticsMd $DeepAnalyticsDocxUpdate
    Write-Warning "Создана обновленная копия Word: $DeepAnalyticsDocxUpdate"
}
try {
    New-DocxFromMarkdown $CompetitorAnalysisMd $CompetitorAnalysisDocx
} catch {
    Write-Warning "Word-документ анализа конкурентов не обновлен: $($_.Exception.Message)"
    New-DocxFromMarkdown $CompetitorAnalysisMd $CompetitorAnalysisDocxUpdate
    Write-Warning "Создана обновленная копия Word: $CompetitorAnalysisDocxUpdate"
}
try {
    New-DocxFromMarkdown $RuMd $RuDocx
} catch {
    Write-Warning "Основной Word-документ не обновлен: $($_.Exception.Message)"
    New-DocxFromMarkdown $RuMd $RuDocxCountryUpdate
    Write-Warning "Создана обновленная копия Word: $RuDocxCountryUpdate"
}
try {
    New-Xlsx $RuXlsx
} catch {
    Write-Warning "Excel-файл не обновлен: $($_.Exception.Message)"
    New-Xlsx $RuXlsxCountryUpdate
    Write-Warning "Создана обновленная копия Excel: $RuXlsxCountryUpdate"
}

Write-Output $RuMd
Write-Output $RuXlsx
Write-Output $RuDocx
Write-Output $DeepAnalyticsMd
Write-Output $DeepAnalyticsDocx
if (Test-Path -LiteralPath $DeepAnalyticsDocxUpdate) { Write-Output $DeepAnalyticsDocxUpdate }
Write-Output $CompetitorAnalysisMd
Write-Output $CompetitorAnalysisDocx
if (Test-Path -LiteralPath $CompetitorAnalysisDocxUpdate) { Write-Output $CompetitorAnalysisDocxUpdate }
if (Test-Path -LiteralPath $RuDocxCountryUpdate) { Write-Output $RuDocxCountryUpdate }
if (Test-Path -LiteralPath $RuXlsxCountryUpdate) { Write-Output $RuXlsxCountryUpdate }

