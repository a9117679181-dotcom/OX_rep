# OX Network - money flow

Статус: финансово-продуктовая схема для юридического исследования. Это не юридическое заключение.

## Обязательная исследовательская рамка

- **ASSUMPTION:** OX не принимает игроков напрямую в регулируемых странах.
- **ASSUMPTION:** OX работает как B2B/B2B2C-инфраструктура через локально лицензированных операторов.
- **ASSUMPTION:** локальный оператор дает игроков, локальную лицензионную рамку, локальный маркетинг и отношения с пользователем.
- **ASSUMPTION:** OX дает технологию, network jackpot architecture, смарт-контракт/proof-layer, выбор событий, расчет выплат, аудит и операционное сопровождение.
- Главный юридический вопрос: является ли OX просто B2B supplier/software provider или фактическим gambling co-operator.
- Главный риск: единый трансграничный globalPool до legal approval.
- Главный исследовательский вопрос: какие poolScope и custody modes допустимы: Direct OX Mode, Operator-Controlled Escrow Mode, operatorPool, countryPool, licensePool или globalPool.

## Базовая модель средств

**ASSUMPTION:** стартовая расчетная валюта MVP - USDC. Согласованная базовая цена одной линии `Суперэкспресс 15` для MVP - 1 USDC. Цена должна оставаться параметром тиража (`comboPrice`): при росте jackpot и anti-whale риска она может быть повышена до открытия продаж по заранее описанным правилам, но не меняется после статуса Open.

**ASSUMPTION:** базовая экономика одного тиража:

| Поток | Доля от оборота | Назначение |
|---|---:|---|
| Prize pool | 80% | Обычные выплаты победителям |
| Platform fee | 10% | Доход OX/операционные расходы/возможный revenue share |
| Jackpot contribution | 10% | Пополнение джекпота следующего тиража |

В продуктовых ТЗ jackpot contribution текущего тиража не добавляется в active jackpot текущего тиража. Active jackpot должен быть зафиксирован до открытия продаж.

## Возможный flow покупки

1. Игрок проходит через локального оператора.
2. Оператор проводит KYC/AML/age/responsible gambling в пределах своей лицензии.
3. Оператор или Operator Gateway запрашивает у OX разрешение на покупку.
4. OX Backend выдает purchase permit при соблюдении правил.
5. **ASSUMPTION:** средства в USDC поступают в smart contract или иной контролируемый settlement layer по утвержденной юридической схеме.
6. Смарт-контракт фиксирует сумму, drawId, ticket data/hash и принадлежность к оператору/юрисдикции.
7. После закрытия и settlement средства распределяются на prize pool, jackpot contribution и platform fee.

## Возможный flow выплаты

1. OX settlement engine формирует payout manifest.
2. Payout root публикуется on-chain.
3. Automatic executor вызывает claimFor(user), если выплата не заблокирована KYC/AML, санкциями, апелляцией или emergency pause.
4. Пользователь получает USDC на кошелек.
5. Если automatic executor не сработал, доступен fallback manual claim.
6. Публичная история выплат фиксирует drawId, сумму, wallet, tx hash, payout level и время.

## Revenue share и operator economics

**ASSUMPTION:** локальный оператор получает долю комиссии или оборота за подключение своей аудитории к OX. В стратегическом документе приведена рабочая гипотеза простой модели для первых партнеров: 5% оборота локальному оператору. Эта цифра требует проверки в финансовой модели, переговорах и локальном праве.

**ASSUMPTION:** партнерские и operator revenue share выплаты не должны идти из prize pool, jackpot funds или средств, зарезервированных под выплаты игрокам.

Юридически чувствительный вопрос: если OX и оператор делят gaming revenue, это может усиливать аргумент, что OX и оператор совместно участвуют в gambling operation, а не находятся в обычных отношениях software supplier/licensee.

## Ключевые юридические вопросы money flow

1. Кто legally accepts stake/ticket purchase: оператор, OX, смарт-контракт, платежный провайдер или network entity?
2. Кто владеет или контролирует funds в выбранном poolScope и custody mode?
3. Является ли smart contract custody, escrow, player account, gambling wallet или technical settlement tool?
4. Можно ли принимать и выплачивать USDC в конкретной юрисдикции?
5. Должны ли средства игроков храниться отдельно по стране, оператору или лицензии?
6. Допустим ли один кошелек/смарт-контракт для глобального пула?
7. Какие налоги возникают у оператора, OX и игрока?
8. Требуется ли локальная отчетность по каждому ticket, payout и jackpot contribution?

## Предварительная risk note

**ASSUMPTION:** единый трансграничный globalPool улучшает ликвидность и размер джекпота, но может быть главным основанием для вывода о cross-border gambling operation. До юридического подтверждения по странам money flow должен проектироваться как network jackpot architecture with operatorPool/countryPool/licensePool first; globalPool only after legal approval. Для B2B-пилота предпочтителен Operator-Controlled Escrow Mode, а Direct OX Mode является отдельным direct crypto risk mode.
