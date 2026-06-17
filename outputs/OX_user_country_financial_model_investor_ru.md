# OX: анализ потенциальных пользователей, стран локализации и финансовой модели

Дата: 2026-06-10  
Статус: рабочий инвесторский документ для дальнейшего анализа, расчетов и юридической проверки  
Проект: OX / Onchain Express  
Стартовый продукт: `Суперэкспресс 15`  
Основной язык документа: русский  

---

## 1. Executive Summary

OX - это on-chain sports express platform: блокчейн-платформа спортивных экспрессов в формате тотализатора, где пользователь выбирает исходы спортивных событий, покупает билет за USDC, участвует в призовом фонде и может получить автоматическую выплату или джекпот.

Стартовый MVP строится вокруг `Суперэкспресса 15`: 15 футбольных событий, выбор исхода `1 / X / 2`, покупка билета за native USDC в сети Base, прозрачная механика призового фонда, джекпот, риск-контроль, KYC/AML по порогам и гео-блокировка до покупки.

Инвесторская логика проекта:

- проверить спрос на понятный спортивный экспресс с крипто-платежом и прозрачными выплатами;
- начать не с глобального запуска, а с ограниченной географии с высокой футбольной культурой, мобильной платежной привычкой и потенциальной crypto-readiness;
- доказать экономику через оборот билетов, повторные покупки, контролируемый CAC, партнерскую атрибуцию и положительную contribution margin;
- не смешивать пользовательские средства, призовой фонд, джекпот и операционные расходы;
- не запускать страну без юридического заключения, лицензии или иной разрешенной структуры.

Первичная географическая гипотеза:

| Очередь | Страны | Логика |
|---|---|---|
| 1 | Нигерия, Кения | Крупная футбольная аудитория, активная betting-культура, цифровые платежи, сильный интерес к crypto, англоязычная база |
| 2 | Гана, Танзания, Уганда, Замбия | Региональное расширение после первых данных, похожие пользовательские паттерны, локальные betting-рынки |
| 3 / watchlist | Бразилия, Казахстан, Узбекистан, ЮАР, Вьетнам, Филиппины | Коммерчески интересны, но требуют отдельной юридической, платежной и операционной проверки |

Ключевой экономический принцип MVP:

| Поток | Доля валидного оборота тиража | Назначение |
|---|---:|---|
| Призовой фонд | 80% | Выплаты обычным призовым уровням |
| Комиссия платформы | 10% | Валовая выручка OX и операционные расходы |
| Взнос в следующий джекпот | 10% | Пополнение джекпота следующего тиража |

Из комиссии платформы в MVP резервируется 20% комиссии на gas reserve. Поэтому базовая чистая операционная маржа до прочих расходов равна примерно 8% от валидного оборота.

Главный вывод для инвестора: OX не должен доказывать всю глобальную стратегию в MVP. MVP должен доказать, что выбранная аудитория покупает билеты, возвращается в следующие тиражи, понимает правила, доверяет выплатам, а unit economics выдерживает CPA, юридические, KYC/AML, gas, oracle, support и marketing costs.

---

## 2. Описание продукта

### 2.1. Что такое OX

Рабочее продуктовое описание:

> OX - спортивный экспресс в формате тотализатора, где пользователи покупают комбинации исходов спортивных событий, а призовой фонд распределяется по заранее описанным правилам.

Пользовательский сценарий должен оставаться простым:

```text
Выбери исходы спортивных событий, купи билет, следи за результатами, получи выигрыш автоматически.
```

Технически OX объединяет:

- пользовательский интерфейс;
- backend и базу данных;
- смарт-контракты;
- серверный агрегатор спортивных результатов;
- settlement engine для расчета итогов;
- Merkle settlement и sponsored claims;
- relayer для автоматической отправки выплат;
- админ-панель;
- risk/compliance layer;
- аналитику и отчеты.

### 2.2. MVP

В MVP входит:

- `Суперэкспресс 15`;
- футбол как стартовый спорт;
- 15 событий;
- 3 исхода на событие: `1 / X / 2`;
- одиночные билеты;
- системные ставки, если они проходят лимиты риска;
- native USDC;
- сеть Base;
- PWA вместо отдельного мобильного приложения;
- джекпот и обычные призовые уровни;
- автоматический пользовательский опыт выплат;
- ручной fallback claim;
- админ-панель;
- базовая аналитика;
- журнал аудита;
- compliance-конфигурация стран;
- KYC/AML по порогам и risk triggers;
- блокировка запрещенных стран до покупки.

### 2.3. Что не входит в MVP

В MVP не входит:

- `Мегаэкспресс 16`;
- токен OX;
- DEX/listing/token-механика;
- staking;
- revenue share token;
- полноценный sportsbook;
- live betting;
- casino games;
- фиатные платежи;
- мультисетевой запуск;
- мобильное приложение App Store / Google Play;
- массовая RevShare-партнерка;
- агрессивные бонусы;
- автоматическое формирование матчей без контроля администратора.

Эти направления можно рассматривать только после того, как базовый продукт подтвердит спрос, безопасность выплат и операционную устойчивость.

### 2.4. Post-MVP

Post-MVP развитие:

- `Мегаэкспресс 16` как отдельный более крупный продукт;
- новые спортивные дисциплины, если они подходят под формат экспресса;
- расширенная партнерская программа;
- партнерский кабинет;
- advanced analytics;
- дополнительные страны после legal review;
- дополнительные языки;
- более глубокая автоматизация оракула;
- token/DEX/listing как отдельный стратегический этап после юридической и финансовой проверки.

---

## 3. Потенциальные пользователи

### 3.1. Сегменты

| Сегмент | Мотивация | Барьеры | Доверительные факторы | Ожидаемое действие | Метрики проверки |
|---|---|---|---|---|---|
| Футбольный игрок экспрессов | Понятный формат 15 матчей, шанс на крупный выигрыш, привычная логика прогнозов | Недоверие к crypto, сложность кошелька, вопрос лицензии | Простые правила, видимый призовой фонд, прозрачная цена билета, автоматическая выплата | Покупает один билет на тираж | Conversion to first ticket, repeat purchase, average ticket |
| Jackpot-oriented пользователь | Интерес к большому джекпоту за малый билет | Риск восприятия как лотереи, ожидание "легких денег" | Честное объяснение вероятностей, responsible gaming, visible jackpot | Покупает регулярно при привлекательном jackpot | Jackpot CTR, ticket conversion by jackpot size, retention |
| Mobile-first пользователь | Удобство PWA, быстрый вход с телефона, привычка к мобильным платежам | Wallet onboarding, USDC acquisition | Минимум шагов, ясный статус транзакции, локальный язык | Подключает кошелек и покупает билет без desktop | Mobile conversion, wallet connect success, payment failure rate |
| Crypto-native пользователь | USDC, on-chain прозрачность, self-custody, проверяемые выплаты | Недоверие к централизованному backend permit, гео-KYC | Публичные правила, контракты, audit trail, Merkle proof | Покупает и проверяет payout path | Wallet repeat rate, proof views, manual claim usage |
| Партнерский трафик | Приходит через спортивные медиа, инфлюенсеров, комьюнити | Низкое качество трафика, CPA-fraud, запрещенные страны | Разрешенные каналы, UTM/ref attribution, fraud control | Делает qualified first purchase | CPA approved rate, fraud rate, CAC, LTV by partner |
| High-value пользователь | Готов покупать дорогие системные билеты | KYC, лимиты, риск full coverage, AML | KYC до крупной ставки, лимиты, risk engine, честные правила | Проходит KYC до крупного объема | KYC pass rate, high-value GMV, blocked risky volume |

### 3.2. Основной пользователь MVP

Основной пользователь MVP:

- интересуется футболом;
- понимает формат экспресса, тотализатора или спортивных прогнозов;
- готов купить небольшой билет;
- имеет криптокошелек или готов его подключить;
- может использовать USDC или получить USDC через партнерский onboarding;
- ценит прозрачный призовой фонд;
- хочет понятную механику без сложного трейдинга;
- использует мобильный web/PWA.

OX не должен требовать от пользователя глубокого понимания блокчейна. Интерфейс должен объяснять продукт через действия: выбор исходов, цена, призовой фонд, джекпот, статус билета, результат, выплата.

### 3.3. Почему пользователь купит билет

Пользовательская причина покупки не должна строиться на обещании выигрыша. Реальные мотивы:

- футбол уже является массовой привычкой и социальной темой;
- формат экспресса понятен пользователям betting-рынков;
- джекпот дает эмоциональный повод участвовать в тираже;
- USDC снижает валютную неопределенность в странах с нестабильной локальной валютой, но создает отдельный compliance-риск;
- прозрачный призовой фонд и автоматические выплаты могут отличать OX от непрозрачных локальных продуктов;
- PWA снижает friction по сравнению с отдельным приложением.

### 3.4. Что нужно доказать пользовательскими метриками

Минимальный набор метрик:

| Группа | Метрики |
|---|---|
| Acquisition | visits, source, country, partner, campaign, UTM |
| Activation | wallet connect rate, USDC readiness, KYC required rate, country blocked rate |
| Purchase | first ticket conversion, ticket price, combinations count, failed purchase rate |
| Retention | repeat buyers, tickets per user per month, cohort retention by country |
| Economy | GMV, platform fee, gas reserve, jackpot top-up, net platform revenue |
| Risk | blocked wallets, high-value attempts, VPN/proxy flags, suspicious linked wallets |
| Partner quality | qualified players, CPA approved/rejected, LTV by partner, fraud flags |

---

## 4. Страны локализации

### 4.1. Общий принцип выбора стран

Страны нельзя выбирать только по размеру рынка. Для OX важны одновременно:

- футбольная и betting-культура;
- digital/mobile penetration;
- привычка к мобильным платежам или digital finance;
- crypto-readiness;
- допустимость betting/totalisator/lottery-like продукта;
- возможность использовать USDC или законный crypto-payment flow;
- управляемость AML/sanctions риска;
- возможность легального маркетинга;
- наличие локальных партнеров и sports media.

### 4.2. Очередь 1: Нигерия и Кения

| Страна | Почему интересна | Локализация | Пользовательская гипотеза | Legal blockers | Payments / crypto readiness | Каналы |
|---|---|---|---|---|---|---|
| Нигерия | Крупнейший рынок очереди, сильная футбольная культура, высокая crypto-активность, англоязычная база | English first, затем локальные сообщения для Lagos/Abuja/Port Harcourt | Пользователь готов покупать небольшие билеты, если onboarding в USDC прост и правила прозрачны | Проверить федеральные и state-level betting/lottery rules, рекламу, crypto payments, AML, налоговую модель | Chainalysis ставит Nigeria на 6 место в Global Crypto Adoption Index 2025; DataReportal фиксирует 107 млн internet users в 2025 | Football media, Telegram/X, sports influencers, affiliate partners, local crypto communities |
| Кения | Сильная betting-культура, высокая мобильная платежная привычка, английский/суахили, активная регуляторная среда | English + Swahili | Пользователь привык к mobile-first betting и может принять PWA, если USDC onboarding не ломает путь | Gambling Control Act 2025, GRA licensing, online gambling, advertising, responsible gaming, taxes, crypto payments | DataReportal: mobile connections 121% of population, internet penetration 48% in 2025 | Sports media, mobile-first partners, football communities, local influencers under advertising rules |

Нигерия - крупнейшая opportunity, но юридически сложнее из-за многослойной структуры betting/lottery/crypto. Кения выглядит более операционно понятной как mobile-first рынок, но требует строгой работы с Gambling Regulatory Authority, рекламными ограничениями и responsible gaming.

### 4.3. Очередь 2: Гана, Танзания, Уганда, Замбия

| Страна | Почему интересна | Локализация | Пользовательская гипотеза | Legal blockers | Payments / crypto readiness | Каналы |
|---|---|---|---|---|---|---|
| Гана | Англоязычный рынок, футбол, высокая internet penetration среди стран второй очереди | English | Может стать аккуратным вторым англоязычным рынком после Nigeria/Kenya | Gaming Commission licensing, AML/CFT, advertising, payment rules, crypto treatment | DataReportal: 24.3 млн internet users и 69.9% penetration в 2025 | Football pages, Facebook/YouTube, local sports media, affiliate partners |
| Танзания | Массовая mobile penetration, betting-регулятор, суахили как важный язык региона | Swahili + English support | Пользовательский потенциал связан с mobile-first sport communities | Gaming Board of Tanzania, лицензия, online gaming sites, payment/KYC, advertising | DataReportal: 79.0 млн mobile connections, 20.2 млн internet users в 2025 | Swahili sports communities, local affiliates, football media |
| Уганда | Регулируемый gaming/betting сектор, football interest, региональная близость к Kenya/Tanzania | English | Расширение после доказательства Kenya/Tanzania playbook | NLGRB licensing, responsible gaming, advertising, payment/KYC, online betting permissions | DataReportal: 38.6 млн mobile connections, 14.2 млн internet users в 2025 | Local sports communities, partner campaigns, regional media |
| Замбия | Англоязычный рынок, football interest, потенциальный regional expansion case | English | Небольшой, но полезный рынок для проверки экономики в менее крупной стране | Betting licensing, tax, advertising, crypto payments, AML | DataReportal: 19.9 млн mobile connections, 7.13 млн internet users в 2025 | Sports media, affiliate partners, focused campaigns |

Вторая очередь не должна запускаться одновременно. Правильный порядок: выбрать 1-2 страны после первых данных по Nigeria/Kenya, затем запускать по одной стране с отдельным legal memo, localized onboarding и country KPI.

### 4.4. Очередь 3 / watchlist

| Страна | Почему интересна | Почему не запускать сразу | Условие перехода из watchlist |
|---|---|---|---|
| Бразилия | Огромный football market, Chainalysis ставит Brazil на 5 место crypto adoption 2025 | Регулируемый рынок fixed-odds betting, local authorization, `.bet.br`, local entity, consumer protection, likely crypto-payment restrictions | Brazilian legal counsel confirms permitted model, payment flow, licensing route and marketing |
| Казахстан | Русскоязычная аудитория, sports betting familiarity, региональный интерес | Нужны лицензия, payment rules, server/data requirements, crypto treatment, advertising review | Local legal memo + payment partner + sanctions/AML review |
| Узбекистан | Потенциальный рынок Центральной Азии | Высокая неопределенность по gambling, payments, ads and KYC | Separate legal clearance and low-risk launch structure |
| ЮАР | Регулируемый betting market, платежеспособная аудитория | Сложная licensing architecture, provincial betting rules, online gambling restrictions, crypto-payment uncertainty | Provincial/license pathway confirmed |
| Вьетнам | Высокий интерес к crypto и digital products | Gambling for local residents is highly restricted; betting product risk is high | Only after explicit legal route |
| Филиппины | Gaming infrastructure history and English usage | После изменений вокруг offshore gaming/POGO/IGL зона повышенного риска | Only after detailed legal and reputational review |

### 4.5. Red zone для MVP

В MVP нельзя обслуживать и нельзя таргетировать:

- США;
- Канада;
- Великобритания;
- ЕС/ЕЭЗ;
- Австралия;
- Индия;
- Индонезия;
- Китай;
- Россия и Беларусь;
- Иран, Северная Корея;
- Турция;
- ОАЭ, Саудовская Аравия, Катар, Кувейт;
- санкционные территории;
- страны, где gambling/betting/online money games запрещены или требуют отдельной лицензии, которой у OX нет.

Операционное правило:

```text
Запрещенная страна блокируется до покупки билета.
Маркетинг на red zone запрещен.
Список стран должен быть backend/compliance-конфигурацией и обновляться без деплоя смарт-контрактов.
```

---

## 5. Рынок и конкуренты

### 5.1. Рыночная логика

Для MVP не нужно доказывать весь глобальный betting market. Нужно доказать более узкую opportunity:

```text
football-first, mobile-first, crypto-compatible users in selected regulated or legally addressable countries.
```

Для оценки стран используются proxy-показатели:

- population and median age;
- internet users and penetration;
- mobile connections;
- social media reach;
- crypto adoption;
- maturity of betting regulation;
- football and sports media density;
- available partner channels;
- expected CAC;
- launch compliance complexity.

### 5.2. Digital и crypto signals

| Страна | Digital signal 2025 | Crypto signal | Вывод для OX |
|---|---|---|---|
| Нигерия | 107 млн internet users; 150 млн mobile connections | Chainalysis 2025: Nigeria rank 6 | Крупный рынок с сильной crypto-гипотезой, но legal complexity высокая |
| Кения | 27.4 млн internet users; mobile connections 121% population | Требует отдельной country crypto/payment проверки | Хороший mobile-first рынок, но нужно строго пройти GRA/licensing |
| Гана | 24.3 млн internet users; 69.9% penetration | Требует проверки | Сильный digital signal для 2 очереди |
| Танзания | 79.0 млн mobile connections; 20.2 млн internet users | Требует проверки | Интересна при Swahili localization и mobile-first GTM |
| Уганда | 38.6 млн mobile connections; 14.2 млн internet users | Требует проверки | Подходит как региональное расширение после Kenya/Tanzania |
| Замбия | 19.9 млн mobile connections; 7.13 млн internet users | Требует проверки | Небольшой рынок для controlled expansion |
| Бразилия | Крупный digital/football market | Chainalysis 2025: Brazil rank 5 | Commercially strong, but legal/payment barriers make it watchlist |

### 5.3. Конкурентная среда

OX конкурирует не только с crypto betting products. В каждой стране будут разные конкурентные группы:

- локальные licensed sportsbooks;
- jackpot betting products;
- football pools and lotteries;
- social betting communities and tipsters;
- offshore crypto betting products;
- prediction-style products;
- informal betting groups.

OX не должен позиционироваться как "лучшие коэффициенты", потому что pari-mutuel модель не является классической букмекерской линией. Более сильное позиционирование:

- понятный фиксированный формат тиража;
- прозрачный призовой фонд;
- джекпот;
- USDC settlement;
- автоматический payout UX;
- публичные правила до покупки;
- запрет изменения параметров открытого тиража.

### 5.4. Где у OX преимущество

Преимущество OX может появиться там, где одновременно есть:

- недоверие к непрозрачным правилам;
- интерес к football jackpots;
- пользовательская готовность к digital wallet;
- локальные партнеры, которые могут объяснить механику;
- regulatory path для betting/totalisator/lottery-like продукта;
- допустимый crypto-payment или crypto-settlement flow.

Если legal/payment flow запрещает USDC в ставках или выплатах, страна не подходит для core OX MVP без изменения платежной архитектуры.

---

## 6. Бизнес-модель

### 6.1. Основная экономика тиража

Базовая экономика MVP:

| Компонент | Значение | Комментарий |
|---|---:|---|
| Prize Pool | 80% валидного оборота | Распределяется между обычными призовыми уровнями |
| Platform Fee | 10% валидного оборота | Валовая выручка OX |
| Jackpot Contribution | 10% валидного оборота | Уходит в джекпот следующего тиража |
| Gas Reserve | 20% от platform fee | Базовый MVP-параметр для automatic sponsored claims |
| Net Platform Revenue до прочих расходов | около 8% оборота | 10% fee минус 20% gas reserve от fee |

Пользовательские средства не используются для:

- операционных расходов;
- партнерских выплат;
- top-up джекпота;
- emergency withdrawals;
- выплат партнерам;
- компенсации ошибок команды.

### 6.2. Джекпот

MVP фиксирует:

- 15/15 является отдельным джекпотным уровнем;
- active jackpot фиксируется до открытия продаж;
- 10% текущего оборота идет в джекпот следующего тиража;
- минимальный публичный джекпот MVP: 5 000 USDC;
- если нужно пополнение до минимума, оно идет из jackpot support reserve, а не из prize pool;
- если jackpot выигран, победители получают 90% active jackpot, 10% переносится дальше;
- если jackpot не выигран, он переносится дальше по правилам.

Экономический риск: минимальный джекпот повышает маркетинговую привлекательность, но при слабом обороте создает нагрузку на резерв проекта.

### 6.3. Партнерская модель

Стартовая партнерская модель:

- referral links;
- referral codes;
- UTM;
- qualified player rules;
- CPA $15 как гипотеза, не публичная гарантия;
- CPA cap;
- fraud control;
- compliance filters;
- manual finance approval for payouts;
- RevShare только для ограниченного числа проверенных партнеров после финансового согласования.

Правило:

```text
Партнерские выплаты являются операционными расходами OX и не выплачиваются из prize pool, jackpot или пользовательских средств.
```

### 6.4. Основные драйверы экономики

| Драйвер | Почему важен |
|---|---|
| Average ticket | Прямо влияет на GMV и platform fee |
| Tickets per active user | Определяет повторяемость экономики |
| Active users by country | Показывает реальный TAM внутри разрешенных рынков |
| Repeat purchase rate | Ключ к LTV |
| CPA / CAC | Главный риск партнерской модели |
| Jackpot top-up | Может съедать маржу на раннем этапе |
| KYC/AML cost | Растет при high-value пользователях и юридических требованиях |
| Gas cost | Влияет на sponsored claims и net revenue |
| Legal/licensing cost | Может задержать запуск и увеличить runway |
| Fraud rate | Может разрушить CPA economics и compliance posture |

---

## 7. Финансовая модель

Отдельная XLSX-модель должна быть основным расчетным приложением к этому документу. В документе фиксируется логика модели и сценарии.

### 7.1. Воронка

Финансовая модель должна считать:

```text
Visits -> eligible users -> wallet connected -> first ticket buyers -> active paying users -> repeat buyers -> retained cohorts
```

Минимальные входные параметры:

- monthly visits by country;
- blocked country rate;
- wallet connect conversion;
- USDC readiness conversion;
- first ticket conversion;
- repeat purchase rate;
- tickets per active user per month;
- average ticket;
- partner share of traffic;
- CPA approved rate;
- fraud rejection rate.

### 7.2. Доходы

Модель считает:

- gross ticket volume / GMV;
- prize pool;
- platform fee;
- jackpot contribution;
- gas reserve;
- net platform revenue before OPEX;
- jackpot top-up impact;
- refunds/voided draw impact;
- partner-attributed revenue.

### 7.3. Расходы

Модель считает:

| Категория | Примеры |
|---|---|
| Marketing | CPA, content, local partners, sports media, community campaigns |
| KYC/KYB | user verification, partner verification, sanctions/AML checks |
| Legal | country memos, licensing, tax, advertising review |
| Audit/Security | smart contract audit, backend audit, penetration tests |
| Oracle/Data | sports data APIs, fallback procedures, result verification |
| Gas | sponsored claims above/below gas reserve |
| Product/Dev | development team, QA, DevOps, analytics |
| Infrastructure | hosting, monitoring, indexer, backups, observability |
| Support | user support, partner support, dispute handling |
| Jackpot reserve | top-up to minimum public jackpot |

### 7.4. Unit economics

Минимальные показатели:

- CAC;
- CPA approved cost;
- LTV estimate;
- ARPU;
- ARPPU;
- average ticket;
- tickets per user;
- net revenue per paying user;
- gross margin after gas reserve;
- contribution margin after variable costs;
- payback period;
- break-even GMV.

Базовая формула break-even:

```text
Break-even monthly GMV = Monthly fixed costs / net platform margin
```

Если net platform margin до OPEX равна 8%, то для покрытия 100 000 USDC фиксированных месячных расходов нужен ориентировочный валидный оборот:

```text
100 000 / 0.08 = 1 250 000 USDC GMV в месяц
```

Это не прогноз, а контрольная формула для проверки масштаба.

### 7.5. Сценарии

| Сценарий | Логика | Что проверяет |
|---|---|---|
| Conservative | Медленный рост, высокий CAC, низкий retention, слабый average ticket | Сколько runway нужно, если market education сложнее ожиданий |
| Base | Контролируемый запуск Nigeria/Kenya, затем 1-2 страны второй очереди | Основная инвесторская гипотеза |
| Upside | Быстрый партнерский рост, высокий repeat, сильный jackpot pull | Потолок при успешном GTM и контролируемом legal expansion |

Сценарии должны считаться на 12/24/36 месяцев.

### 7.6. Stress tests

Обязательные stress tests:

- CPA растет на 50-100%;
- average ticket ниже base case на 30%;
- retention ниже base case на 50%;
- legal approval задерживает страну на 3-6 месяцев;
- jackpot top-up выше плана;
- KYC pass rate ниже ожиданий;
- partner fraud rate выше ожиданий;
- gas cost выше gas reserve;
- sports data/oracle cost выше плана;
- страна первой очереди не проходит legal gate.

---

## 8. Go-to-market

### 8.1. Принцип запуска

OX не должен запускаться как "global crypto betting". Правильный запуск:

```text
country-by-country, partner-controlled, compliance-first, measured by cohorts.
```

Каждая страна запускается только после:

- legal memo;
- payment/USDC memo;
- KYC/AML threshold approval;
- advertising review;
- responsible gaming requirements;
- launch budget approval;
- local partner approval;
- fraud-monitoring setup;
- support and dispute process.

### 8.2. Каналы первой очереди

Нигерия:

- sports media;
- football communities;
- Telegram/X groups;
- YouTube/TikTok sports explainers;
- local crypto communities;
- affiliate partners with strict compliance;
- influencer campaigns only after advertising review.

Кения:

- mobile-first sports communities;
- local football media;
- Swahili explainers;
- regulated partner campaigns;
- sports content creators;
- community-led onboarding;
- no ad claims that imply guaranteed winning or risk-free betting.

### 8.3. Каналы второй очереди

Гана:

- English football media;
- Facebook/YouTube sports pages;
- local sports podcasts;
- affiliate partners.

Танзания:

- Swahili football communities;
- mobile-first campaigns;
- local partners;
- football event tie-ins where legally allowed.

Уганда:

- football communities;
- sports content pages;
- regional affiliates;
- responsible gaming messaging.

Замбия:

- focused partner tests;
- local sports media;
- low-budget cohort validation before scale.

### 8.4. KPI запуска страны

| KPI | Минимальный смысл |
|---|---|
| Legal go/no-go | Есть письменное юридическое основание для запуска |
| Country blocked rate | Не растет аномально из-за VPN/proxy и red zone traffic |
| Wallet connect rate | Путь подключения кошелька не ломает воронку |
| First ticket conversion | Пользователь понимает продукт |
| Repeat purchase | Есть регулярность участия в тиражах |
| CAC / LTV | Привлечение не съедает экономику |
| CPA fraud rate | Партнерка контролируема |
| Support tickets per purchase | UX не перегружает поддержку |
| KYC pass rate | High-value path работает без репутационных конфликтов |
| Payout success rate | Автоматическая выплата подтверждает основной promise |

---

## 9. Legal, Compliance и риски

### 9.1. Юридическая классификация

OX нельзя одинаково классифицировать во всех странах. Возможные классификации:

- тотализатор;
- betting;
- lottery-like product;
- gambling;
- pool betting;
- prediction/event product;
- digital asset / crypto payment product.

Архитектура и бизнес-документы не должны заранее утверждать одну универсальную классификацию. Для каждой страны нужен отдельный legal memo.

### 9.2. KYC/AML

Рабочая формула:

```text
KYC на входе по риску и объему ставки,
а не на выходе после честного выигрыша.
```

KYC применяется:

- до крупной ставки;
- при high-risk wallet;
- при санкционном/AML-флаге;
- при подозрении на связанные кошельки;
- при юридическом требовании страны;
- при partner/KYB requirement.

KYC не должен становиться скрытым способом не выплатить честный выигрыш после того, как ставка уже была принята.

### 9.3. Гео-блокировка

Принятая модель:

```text
backend-signed purchase permit
```

Backend проверяет страну, VPN/proxy/Tor, санкционный риск, AML-риск, KYC-статус, лимиты и compliance-конфигурацию. Смарт-контракт принимает покупку только с валидным signed permit.

### 9.4. Основные риски

| Риск | Влияние | Контроль |
|---|---|---|
| Страна не проходит legal review | Нельзя запускать рынок | Country gate до разработки/маркетинга |
| Crypto payments запрещены | Core USDC-модель не работает | Payment memo, alternative structure only after board approval |
| Реклама ограничена | CAC растет, партнерка сужается | Pre-approved ad templates, local counsel |
| CPA-fraud | Съедает бюджет, создает AML-риск | Qualified player rules, fraud flags, hold period |
| Low retention | LTV ниже CAC | Cohort analysis, product iteration |
| Jackpot top-up pressure | Резерв расходуется быстрее | Jackpot reserve policy, minimum jackpot review |
| High-value abuse / full coverage | Экономическая атака | Risk engine, limits, dynamic parameters |
| Oracle/data incident | Спорные результаты | Result manifest, fallback, appeal window |
| Санкционный адрес | AML/legal breach | Wallet screening before permit |
| Репутационный конфликт по выплате | Потеря доверия | KYC before stake, clear rules, audit log |

---

## 10. Инвесторский вывод

### 10.1. Что доказывает MVP

MVP должен доказать:

- пользователи понимают `Суперэкспресс 15`;
- wallet/USDC onboarding не ломает покупку;
- пользователи готовы покупать повторно;
- transparent prize pool и jackpot повышают conversion;
- автоматическая выплата работает и воспринимается как преимущество;
- KYC до крупной ставки не разрушает UX обычного пользователя;
- country-by-country GTM дешевле и безопаснее глобального запуска;
- CAC контролируется через партнеров и organic sports channels;
- platform fee и repeat behavior дают путь к positive contribution margin.

### 10.2. Milestones до mainnet

| Milestone | Условие |
|---|---|
| Product lock | Финальный MVP scope без token/DEX/live betting |
| Legal gates | Nigeria/Kenya legal memos и country decision |
| Financial model lock | Base/conservative/upside model approved |
| Security gate | Smart contract/backend/security audit completed |
| Testnet MVP | Полный цикл: ticket -> result -> settlement -> payout |
| Limited mainnet | Ограниченный запуск в разрешенной стране/странах |
| Country expansion | Только после cohort, CAC/LTV, support, risk data |

### 10.3. Финансирование

Сумма финансирования должна рассчитываться не от "глобального TAM", а от:

- 12-18 месяцев runway;
- legal/licensing по первой очереди;
- разработка MVP и аудит;
- jackpot support reserve;
- initial CPA/marketing budget;
- KYC/AML and data providers;
- support and operations;
- contingency for legal delays.

В финансовой модели нужно считать минимум три варианта:

- conservative: больше runway, меньше GMV, выше CAC;
- base: контролируемый запуск первой очереди и 1-2 страны второй очереди;
- upside: ускоренное масштабирование после подтверждения repeat purchase и partner quality.

### 10.4. Go/no-go метрики

Go для масштабирования:

- legal gate пройден;
- payout success rate стабилен;
- first ticket conversion подтвержден;
- repeat purchase есть в cohort data;
- CAC ниже LTV по зрелым когортам;
- CPA fraud rate управляем;
- support load не растет быстрее GMV;
- jackpot top-up не разрушает резерв;
- KYC/AML не создает массовых блокировок честных пользователей.

No-go или pause:

- страна не проходит legal memo;
- crypto payments/USDC запрещены или не имеют безопасного пути;
- высокие блокировки по VPN/red zone;
- CPA-fraud выше допустимого уровня;
- payout incidents создают репутационный риск;
- average ticket и repeat rate не покрывают CAC;
- джекпотный резерв требует постоянного пополнения без роста GMV.

---

## 11. Приложение: структура финансовой модели

Отдельный файл модели должен содержать вкладки:

| Вкладка | Назначение |
|---|---|
| Assumptions | Все входные гипотезы: экономика тиража, CAC/CPA, ticket behavior, costs |
| Country Rollout | Очереди стран, языки, legal status, launch gates |
| Funnel | Воронка visits -> wallet -> first purchase -> active users |
| Revenue | GMV, prize pool, platform fee, jackpot contribution, gas reserve, net revenue |
| Costs | Marketing, CPA, KYC, legal, audit, infra, gas, support |
| Unit Economics | CAC, LTV, payback, contribution margin, break-even |
| Scenarios | Conservative/base/upside на 12/24/36 месяцев |
| Sensitivity | CPA, retention, average ticket, jackpot top-up, conversion |
| Investor Summary | Funding need, runway, break-even volume, scenario summary |

---

## 12. Контроль качества документа

Документ отвечает на ключевые вопросы:

| Вопрос | Ответ |
|---|---|
| Кто основной пользователь OX? | Футбольный пользователь, знакомый с экспрессами/тотализатором и готовый использовать кошелек/USDC при простом UX |
| Почему он купит билет? | Понятный football format, jackpot, прозрачный prize pool, автоматическая выплата, простые правила |
| Почему 1 очередь - Нигерия и Кения? | Nigeria дает масштаб и crypto signal; Kenya дает mobile-first betting market и понятный regulatory path после GRA review |
| Почему 2 очередь - Гана, Танзания, Уганда, Замбия? | Региональное расширение после первых данных, football/mobile patterns, отдельные licensing paths |
| Почему watchlist не запускать сразу? | Бразилия, ЮАР, Вьетнам, Филиппины, Казахстан и Узбекистан требуют отдельной legal/payment проверки и могут сломать MVP focus |
| Как OX зарабатывает? | 10% platform fee от валидного оборота, из которых в MVP резервируется 20% fee на gas reserve |
| Почему prize pool не смешивается с расходами? | Это базовый trust principle: пользовательские средства идут на призы/джекпот/выплаты, не на marketing, partners или operations |
| Какой оборот нужен для покрытия расходов? | Monthly fixed costs / net platform margin; при 8% net margin 100 000 USDC расходов требует около 1 250 000 USDC GMV |
| Какие legal/compliance условия блокируют запуск? | Нет лицензии/разрешенного статуса, запрет crypto payments, advertising ban, AML/sanctions risk, невозможность KYC/geo-blocking |
| Какие метрики подтверждают масштабирование? | Repeat purchase, CAC < LTV, payout success, controlled fraud, stable support load, low blocked-country leakage |

---

## 13. Источники и примечания

### Внутренние источники OX

- `ТЗ_OX_TXT/02_Этап_01_Ядро_продукта/OX_Этап_01_Ядро_продукта_ТЗ_v3.txt`
- `ТЗ_OX_TXT/04_Этап_03_Билеты_и_системные_ставки/OX_Этап_03_Билеты_и_системные_ставки_ТЗ_v2.txt`
- `ТЗ_OX_TXT/05_Этап_04_Призовой_фонд_и_джекпот/OX_Этап_04_Призовой_фонд_и_джекпот_ТЗ_v2.txt`
- `ТЗ_OX_TXT/13_Этап_12_Комплаенс_и_риски/OX_Этап_12_Комплаенс_и_риски_ТЗ_для_согласования_v1.txt`
- `ТЗ_OX_TXT/14_Этап_13_Партнерка_и_аналитика/OX_Этап_13_Партнерка_и_аналитика_ТЗ_v2.txt`
- `ТЗ_OX_TXT/16_Этап_15_Дорожная_карта_и_задачи/OX_Этап_15_Дорожная_карта_и_задачи_ТЗ_v2.txt`

### Внешние источники для текущей проверки

- DataReportal, Digital 2025: Nigeria - https://datareportal.com/reports/digital-2025-nigeria
- DataReportal, Digital 2025: Kenya - https://datareportal.com/reports/digital-2025-kenya
- DataReportal, Digital 2025: Ghana - https://datareportal.com/reports/digital-2025-ghana
- DataReportal, Digital 2025: Tanzania - https://datareportal.com/reports/digital-2025-tanzania
- DataReportal, Digital 2025: Uganda - https://datareportal.com/reports/digital-2025-uganda
- DataReportal, Digital 2025: Zambia - https://datareportal.com/reports/digital-2025-zambia
- Chainalysis, 2025 Global Crypto Adoption Index - https://www.chainalysis.com/blog/2025-global-crypto-adoption-index/
- Gambling Regulatory Authority of Kenya - https://gra.go.ke/about/
- Kenya Gambling Control Act 2025 - https://gra.go.ke/wp-content/uploads/2026/03/Gambling-Control-Act.pdf
- Gaming Commission of Ghana - https://www.gamingcommission.gov.gh/
- Gaming Board of Tanzania - https://www.gamingboard.go.tz/
- Uganda National Lotteries and Gaming Regulatory Board - https://lgrb.go.ug/
- Brazil Ministry of Finance, Secretaria de Premios e Apostas - https://www.gov.br/fazenda/pt-br/composicao/orgaos/secretaria-de-premios-e-apostas

### Важное ограничение

Этот документ не является юридическим заключением, инвестиционной рекомендацией или финальной финансовой моделью. Все страны, платежные механики, рекламные каналы, KYC/AML-пороги, налоговые последствия и лицензии должны быть подтверждены профильными юристами и финансовой моделью перед запуском.
