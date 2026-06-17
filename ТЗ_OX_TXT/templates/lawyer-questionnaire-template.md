# Lawyer questionnaire template - OX Network

Статус: шаблон вопросов локальному юристу. Это не юридическое заключение.

Юрисдикция: `[country]`  
Юрист/фирма: `[name]`  
Дата отправки: `[date]`

## 1. Product background

Просим оценить продукт OX Network на основании следующей рабочей рамки:

- **ASSUMPTION:** OX не принимает игроков напрямую в регулируемых странах.
- **ASSUMPTION:** OX работает как B2B/B2B2C-инфраструктура через локально лицензированных операторов.
- **ASSUMPTION:** локальный оператор дает игроков, локальную лицензионную рамку, локальный маркетинг и отношения с пользователем.
- **ASSUMPTION:** OX дает технологию, общий пул, смарт-контракт, выбор событий, расчет выплат, аудит и операционное сопровождение.
- Главный юридический вопрос: является ли OX просто B2B supplier/software provider или фактическим gambling co-operator.
- Главный риск: единый трансграничный global pool.
- Главный исследовательский вопрос: можно ли делать один глобальный пул или нужны country/operator/license-segregated sub-pools.

## 2. Product classification

1. Как в вашей юрисдикции будет классифицирован продукт OX: pool betting, totalizator, sportsbook, lottery, gambling game, prize competition, event contract, software service или другое?
2. Меняется ли классификация, если OX не привлекает игроков напрямую, а работает через локального лицензированного оператора?
3. Имеет ли значение, что результат зависит от спортивных событий и распределения общего пула, а не от fixed odds?
4. Имеет ли значение, что ставки и выплаты планируются в USDC?

## 3. B2B supplier/software provider status

1. Может ли OX работать как B2B supplier/software provider без локальной gambling operator license?
2. Требуется ли OX supplier license, software certification, regulatory approval, registration или local representative?
3. Какие действия OX допустимы для supplier, а какие делают OX co-operator?
4. Делают ли следующие функции OX фактическим co-operator: выбор событий, управление правилами, global pool, расчет выплат, смарт-контракт, аудит?
5. Нужно ли раскрывать роль OX игрокам или регулятору?

## 4. Local licensed operator

1. Может ли локально лицензированный оператор подключать внешний B2B/B2B2C продукт OX?
2. Покрывает ли его лицензия внешний jackpot pool?
3. Какие обязанности обязательно должны остаться у локального оператора?
4. Кто должен быть contracting party для игрока?
5. Может ли локальный оператор использовать свой бренд, маркетинг и пользовательскую поддержку для OX?

## 5. Global pool

1. Можно ли объединять игроков из вашей юрисдикции с игроками из других стран в одном global pool?
2. Если нельзя, допустим ли country-segregated sub-pool?
3. Если country pool недостаточен, нужен ли operator/license-segregated sub-pool?
4. Можно ли смешивать средства игроков разных операторов в одном smart contract?
5. Требуется ли локальное ring-fencing player funds?
6. Требуется ли отдельный локальный jackpot reserve?

## 6. USDC, crypto and smart contracts

1. Можно ли принимать USDC за билет/ставку?
2. Можно ли выплачивать выигрыш в USDC?
3. Может ли локальный оператор проводить fiat-to-USDC или USDC settlement?
4. Как квалифицируется smart contract, который хранит pool и выполняет payout?
5. Требуются ли VASP, payment, e-money, custody или crypto approvals?
6. Нужны ли blockchain analytics/sanctions screening requirements?

## 7. KYC/AML and responsible gambling

1. Кто обязан проводить KYC: оператор, OX или оба?
2. Можно ли делать risk-based KYC до крупной ставки, а не на выводе?
3. Можно ли автоматически выплачивать выигрыш, если билет был принят корректно и нет блокирующих флагов?
4. Какие пороги KYC/AML применяются?
5. Какие требования к self-exclusion, возрасту, responsible gambling и лимитам?

## 8. Revenue share

1. Разрешен ли revenue share между локальным оператором и OX?
2. Можно ли рассчитывать revenue share от platform fee или оборота?
3. Усиливает ли revenue share риск признания OX co-operator?
4. Какие налоги, withholding, VAT/GST или gaming duties применяются?
5. Можно ли проводить B2B settlement в USDC?

## 9. Advertising and affiliates

1. Может ли локальный оператор рекламировать OX jackpot product?
2. Какие disclaimers обязательны?
3. Можно ли указывать размер jackpot?
4. Какие ограничения на affiliates, influencers, bonuses и claims вроде "instant payout"?
5. Какие каналы рекламы запрещены?

## 10. Data protection

1. Какие данные игрока оператор может передавать OX?
2. Является ли wallet address персональными данными?
3. Нужен ли DPA между оператором и OX?
4. Разрешена ли cross-border transfer данных?
5. Какие сроки хранения применимы к ticket logs, payout logs, audit logs и KYC signals?

## 11. Required deliverable

Просим предоставить:

- краткий go/no-go/conditional вывод;
- список обязательных лицензий/approvals;
- анализ B2B supplier vs co-operator;
- отдельный вывод по global pool;
- отдельный вывод по USDC/smart contract;
- список обязательных contract terms;
- список источников с цитатами и ссылками;
- practical launch conditions.
