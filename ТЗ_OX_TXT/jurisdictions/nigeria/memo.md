# Nigeria memo - OX Network legal research

Status: research memo for local counsel review. This is not a legal opinion.

Research date: 2026-06-11  
Project: OX Network / SuperExpress 15  
Jurisdiction: Nigeria

## 0. OX context reviewed

OX Network is framed as B2B/B2B2C infrastructure for a sports jackpot totalisator-style product. OX does not intend to accept players directly in regulated countries. A local licensed operator would provide players, local licence coverage, marketing, support and player relationship. OX would select events, operate rules, smart contract, settlement, payout calculation and global pool.

Main legal question: can OX remain a B2B supplier/software/platform provider, or would Nigerian regulators treat OX as a gambling co-operator, remote operator, pool/jackpot operator, VASP/payment actor or another locally regulated participant?

## 1. Executive summary

| Issue | Finding | Status | Sources |
|---|---|---|---|
| Regulated gambling routes | Nigeria has regulated betting/lottery/gaming routes, but federal/state competence and NLRC status require fresh confirmation after the 2024 Supreme Court decision. | UNCLEAR | NGA-GAM-001, NGA-QA-001, NGA-QA-002 |
| Local operator model | A local operator likely can integrate external software if software, architecture and SLA are disclosed/approved. | LIKELY | NGA-GAM-001 |
| OX direct approval | OX may need direct approval if it is treated as providing gaming facilities, controlling pool/player funds or operating remote gaming. Exact category is unclear. | UNCLEAR | NGA-GAM-001 |
| Global shared pool | No source found expressly permitting cross-border shared liquidity/global jackpot pooling for Nigerian players. | UNKNOWN | Source gap |
| USDC tickets/payouts | No source found allowing USDC in gambling. ICLG says gambling laws do not provide for virtual currencies. | UNCLEAR | NGA-GAM-001, NGA-SEC-002 |
| VASP risk | If OX transfers, exchanges, safeguards or administers virtual assets, SEC VASP/DAX/DAC analysis is likely triggered. | LIKELY | NGA-SEC-002, NGA-SEC-003 |
| AML/KYC | SCUML/DNFBP AML framework is verified generally; gaming-specific AML treatment in this memo relies partly on secondary gaming-law material. | LIKELY | NGA-GAM-001, NGA-SCUML-001 |
| Data protection | NDPA/NDPC rules apply to Nigerian data subjects and cross-border processing/transfer. | VERIFIED | NGA-NDPC-001, NGA-NDPC-002 |

Working recommendation: **RESEARCH MORE / CONDITIONAL GO only after local counsel and regulator confirmation.** Nigeria is not a clean GO for the current global-pool + USDC design. A conditional path may exist through a properly licensed local operator, product approval, software/SLA disclosure, local/state compliance and either no USDC player flow or a separately approved virtual-asset/payment structure.

## 1A. Research Weaknesses

This section records quality-audit weaknesses in the current Nigeria research package. It is intentionally conservative and should be read before relying on any finding above.

### 1A.1 Gambling-law sources are not strong enough for final reliance

Finding: the gambling-specific analysis relies heavily on ICLG 2025, a reputable secondary legal guide, because official NLRC/state regulator materials and official statutes were not fully retrieved.

Status: **VERIFIED**

Evidence: `sources.md` records ICLG as `NGA-GAM-001` and records official NLRC access failure as `NGA-GAP-001`.

Risk: conclusions about licence categories, software/SLA filing, sports betting licences, remote permits, totalisator coverage and gaming AML should not be treated as fully verified until official federal/state materials or local counsel confirm them.

### 1A.2 Federal/state regulator position may be materially outdated or incomplete

Finding: the memo's initial framing of "federal and state regulators" is too broad after the 22 November 2024 Supreme Court decision reported by PwC and Templars.

Status: **LIKELY**

Evidence: PwC and Templars state that the Supreme Court declared the National Lottery Act invalid and shifted/limited regulatory authority toward states, with NLRC jurisdiction reportedly limited to the FCT. [NGA-QA-001], [NGA-QA-002]

Risk: any OX launch analysis must be state-specific. A national/NLRC path may be insufficient or wrong outside the FCT unless current official law or local counsel says otherwise.

### 1A.3 No official judgment was retrieved

Finding: the audit found secondary summaries of the Supreme Court decision, but not the official judgment text.

Status: **UNKNOWN**

Evidence: no official Supreme Court judgment was added to `sources.md`.

Risk: the exact holding, territorial scope, transitional effects, FCT carve-out, treatment of existing licences and effect on sports betting/pool betting must be confirmed by local counsel using the official judgment.

### 1A.4 Local operator licence coverage for OX is not proven

Finding: the research supports only a limited proposition: a licensed operator may likely use disclosed/approved software. It does not prove that a local operator's licence covers OX controlling global pool, smart contract, event selection, settlement and payouts.

Status: **UNCLEAR**

Evidence: ICLG refers to certified software, architecture and SLA, but no source confirms that a supplier may control a cross-border pool or payout engine without direct approval. [NGA-GAM-001]

Risk: prior `LIKELY` language about local operator integration must be read narrowly and not as licence coverage for OX's full operating role.

### 1A.5 Global pool is a source vacuum

Finding: no source found permits Nigerian players to join a global shared betting/jackpot pool or permits shared liquidity across countries/operators/licences.

Status: **UNKNOWN**

Evidence: no source found.

Risk: the recommendation to prepare segregated pools is an architectural risk-control recommendation, not a verified legal requirement.

### 1A.6 Crypto/USDC analysis is incomplete and current-law-sensitive

Finding: the memo correctly treats USDC gambling tickets/payouts as unsupported, but the VASP analysis is not complete because it relies on SEC 2022 rules while ISA 2025 and 2026 SEC circulars appear to update the digital asset framework.

Status: **UNCLEAR**

Evidence: SEC 2022 Digital Asset Rules are source `NGA-SEC-002`; ISA 2025 and SEC 2026 capital circular were added as audit sources `NGA-SEC-005` and `NGA-SEC-006`.

Risk: VASP/DAX/DAC/ARIP conclusions should be treated as issue spotting, not a current-law conclusion.

### 1A.7 CBN VASP banking source gap

Finding: official CBN VASP bank-account guidelines were not directly retrieved in the package.

Status: **UNKNOWN**

Evidence: `NGA-QA-003` records the source gap.

Risk: the research cannot verify banking/payment-rail permissibility for USDC flows.

### 1A.8 Tax section is under-sourced

Finding: the tax section relies on secondary gaming-law material and records most key tax points as UNKNOWN.

Status: **VERIFIED**

Evidence: no primary FIRS/NRS source was added.

Risk: no OX financial model should use the Nigeria memo for GGR, turnover tax, VAT, withholding or revenue-share tax allocation.

### 1A.9 B2B/B2B2C and B2C roles are still partly mixed

Finding: some risk sections discuss "operator" obligations and "OX" obligations together because sources focus on licensed operators, not B2B suppliers. This can blur the difference between player-facing B2C licence duties and OX's supplier/platform duties.

Status: **LIKELY**

Evidence: gaming sources retrieved describe operators/licensees; no primary B2B supplier approval source was found.

Risk: local counsel must separately map obligations for: local operator, OX as software supplier, OX as pool/settlement controller, OX as potential VASP, and OX as data processor/controller.

### 1A.10 Several statements are risk recommendations, not legal conclusions

Finding: statements such as "prepare segregated pool", "local operator should handle first-line complaints" and "partner agreement must cover shortfall" are prudent risk controls, not verified statutory requirements.

Status: **VERIFIED**

Evidence: no source found assigning those exact legal obligations.

Risk: these should remain in the memo as launch conditions/questions, not as confirmed Nigeria legal requirements.

## 2. Product classification

### 2.1 Sportsbook

Finding: OX is not a fixed-odds sportsbook in mechanics, but it is sports-result-based and will likely be reviewed under betting/sports betting regulation.

Status: **LIKELY**

Evidence: ICLG lists betting and sports/horse-race betting as regulated by NLRC and state lottery boards, and states sports betting licences are available. [NGA-GAM-001]

OX impact: Nigerian counsel should assume sports betting regulator attention even if OX argues totalisator/pool betting.

### 2.2 Pool betting / totalisator

Finding: OX has strong pool-betting/totalisator features: users contribute to a common pool; payouts depend on pool size and winner count, not fixed bookmaker odds.

Status: **LIKELY**

Evidence: ICLG states Lagos State Lotteries and Gaming Authority Law 2021 covers online/retail gaming requiring computer programming, randomisers, totalisators and betting services through internet/mobile/terminals. [NGA-GAM-001]

Source limitation: official Lagos law text was not retrieved in this pass. Local counsel must verify.

### 2.3 Lottery-like jackpot

Finding: OX's 15/15 jackpot may be viewed as lottery-like or jackpot/pool prize mechanics, even though outcomes come from sports events.

Status: **UNCLEAR**

Evidence: lottery permits and lottery regulation exist, but retrieved sources do not classify a sports totalisator jackpot as lottery, sports betting or both. [NGA-GAM-001]

OX impact: product approval should explicitly describe the 10% jackpot contribution, 15/15 payout, carryover, display of jackpot and funding source.

### 2.4 Gambling software

Finding: OX backend, smart contract, event selection, settlement engine and payout engine are likely gambling software or technical systems used by a licensed operator.

Status: **LIKELY**

Evidence: ICLG states gambling licence applications include certified software, software architecture and an SLA between operator and software operator. [NGA-GAM-001]

### 2.5 B2B gambling supplier

Finding: A B2B supplier model is plausible but unverified. Sources support software-operator involvement, but do not confirm a supplier-only safe harbour when OX controls pool, events and payouts.

Status: **UNCLEAR**

Evidence: ICLG refers to application materials involving a "software operator" SLA, but also says any person wishing to conduct any form of gaming operations must apply for the relevant licence/permit. [NGA-GAM-001]

### 2.6 Crypto/financial product

Finding: USDC and smart-contract settlement introduce separate digital asset/VASP analysis.

Status: **LIKELY**

Evidence: SEC digital asset rules apply to platforms facilitating trading, exchange and transfer of virtual assets and to persons whose activities involve DLT-related and virtual digital asset services. VASP includes transfer, exchange, safekeeping/administration and related financial services. [NGA-SEC-002]

## 3. Can a local licensed operator offer OX?

### 3.1 External B2B/B2B2C product

Finding: A local licensed operator likely can integrate external software if disclosed and approved as part of its licence/product setup.

Status: **LIKELY**

Evidence: licence application materials include certified software, software architecture and an SLA between the operator and software operator. [NGA-GAM-001]

Unknown: whether an operator can integrate a product where the external supplier controls a global smart-contract pool and cross-border jackpot.

### 3.2 Product approval

Finding: Product/software approval or regulator review is likely required before launch.

Status: **LIKELY**

Evidence: ICLG describes application materials requiring detailed business plan, financial capability, certified software, software architecture and SLA. [NGA-GAM-001]

OX materials likely needed: product math, 80/10/10 split, jackpot rules, payout formulas, settlement diagrams, smart-contract audit, responsible gaming controls and complaint process.

### 3.3 Pool betting / totalisator / jackpot

Finding: sports betting and lottery licence/permit categories exist; Lagos law is described as covering totalisators. Whether OX's exact global jackpot pool is permitted is unknown.

Status: **UNCLEAR**

Evidence: [NGA-GAM-001]

## 4. Does OX need its own local licence or approval?

### 4.1 Supplier/software/platform/vendor approval

Finding: no retrieved source confirms a standalone supplier licence category for OX. However, software architecture, certified software and SLA are part of operator application/review.

Status: **UNCLEAR**

Evidence: [NGA-GAM-001]

Research position: ask local counsel whether OX must be registered or approved as technical service provider, software provider, vendor, platform provider or key supplier under federal and state rules.

### 4.2 Remote operator permit

Finding: if OX is considered to provide gaming facilities to Nigerian players remotely, a Remote Operator Permit or direct approval may be triggered.

Status: **LIKELY**

Evidence: ICLG says offshore operators need Remote Operator Permit before operating in Nigeria, and operators providing facilities for gaming to Nigerian players without NLRC permit commit an offence. [NGA-GAM-001]

OX counter-argument to test: OX does not face players directly and local operator is the player-facing licensee.

### 4.3 Platform/jackpot/pool operator approval

Finding: unknown whether Nigeria has a separate jackpot/pool operator approval category applicable to OX.

Status: **UNKNOWN**

Evidence: no source found.

## 5. Global shared pool

### 5.1 Cross-border pooling

Finding: no source found expressly permitting Nigerian players to join a cross-border sports betting/lottery pool with players from other jurisdictions.

Status: **UNKNOWN**

Evidence: source gap.

### 5.2 Nigerian local operator players in global pool

Finding: this is the highest-risk open issue. A local operator licence may not automatically authorize pooling Nigerian stakes with foreign players, especially if prize funds are held in a global smart contract outside normal local player-fund controls.

Status: **UNCLEAR**

Evidence: ICLG confirms mixed federal/state regulation and state licensing relevance, but does not address shared liquidity. [NGA-GAM-001]

### 5.3 Displaying global jackpot

Finding: advertising a global jackpot is likely subject to both gaming regulator and ARCON advertising approval, and must avoid misleading claims.

Status: **LIKELY**

Evidence: ARCON Act applies to ads directed at Nigerian market and requires legality, honesty, truthfulness and social responsibility; exposing ads without Standards Panel approval is an offence. [NGA-ARCON-001]

Unknown: whether gaming regulator would approve display of a jackpot sourced from non-Nigerian players.

### 5.4 Need for segregated pool

Finding: because shared liquidity is unsupported by available sources, a Nigeria-only, state/operator/licence-segregated pool should be treated as the conservative fallback architecture until local counsel confirms otherwise. This is not a verified legal requirement.

Status: **UNCLEAR**

Evidence: risk-control inference from source gap plus mixed/unstable federal-state regulation. [NGA-GAM-001], [NGA-QA-001], [NGA-QA-002]

## 6. Crypto / USDC / Base

### 6.1 Accepting USDC

Finding: no source found permitting USDC to be accepted for gambling tickets. ICLG states relevant gambling laws do not make provision for virtual currencies in gambling.

Status: **UNCLEAR**

Evidence: [NGA-GAM-001]

### 6.2 Paying winnings in USDC

Finding: no source found permitting USDC payout of gambling winnings.

Status: **UNKNOWN**

Evidence: source gap.

### 6.3 Self-custody wallets

Finding: no gambling-specific source found on self-custody wallets. If OX or operator does not custody but receives transfers from user wallets, VASP/payment treatment remains unclear.

Status: **UNKNOWN**

Evidence: source gap; SEC VASP rules cover transfer/safekeeping/administration for others. [NGA-SEC-002]

### 6.4 VASP

Finding: VASP/DAX/DAC registration may be triggered if OX or the local operator exchanges, transfers, safeguards/administers or provides related financial services for virtual assets.

Status: **LIKELY**

Evidence: SEC VASP definitions and applicability. [NGA-SEC-002]

Mitigating point: SEC rules exclude a technology service provider that merely provides infrastructure/software to a DAX. This helps only if OX does not control funds or transfers. [NGA-SEC-002]

### 6.5 Travel Rule

Finding: no retrieved Nigerian source expressly applying a Travel Rule to this OX gambling use case.

Status: **UNKNOWN**

Evidence: source gap. SEC digital asset rules reviewed did not provide a clear Travel Rule conclusion for this scenario. [NGA-SEC-002]

### 6.6 Wallet and sanctions screening

Finding: sanctions screening is relevant. SCUML links to UN, Nigeria and OFAC sanctions searches; SEC VASP/DAX rules require AML/CFT/PF controls.

Status: **LIKELY**

Evidence: [NGA-SCUML-001], [NGA-SEC-002]

## 7. KYC / AML

### 7.1 Risk-based KYC

Finding: risk-based AML/KYC appears supported for gaming licensees, but the gaming-specific statement is based on a secondary guide rather than primary AML/gaming regulations.

Status: **LIKELY**

Evidence: ICLG states licensees are DNFBPs and are required to comply with a risk-based approach to identify, assess, monitor, manage and mitigate money laundering and terrorist-financing risks. [NGA-GAM-001]

### 7.2 Local operator as KYC provider

Finding: local operator can likely perform player KYC if it is the licensed player-facing operator, but OX must determine whether it has independent AML duties based on its role.

Status: **LIKELY**

Evidence: gaming licensee AML obligations apply to operators/licensees; SCUML supervises DNFBPs. [NGA-GAM-001], [NGA-SCUML-001]

### 7.3 Pseudonymous player ID

Finding: OX receiving only pseudonymous player ID may reduce data exposure but does not automatically remove AML/privacy obligations if data is linkable or OX controls payout/risk decisions.

Status: **LIKELY**

Evidence: NDPA/GAID applies to controllers/processors targeting Nigerian data subjects; no source found exempting pseudonymous gaming IDs. [NGA-NDPC-002]

### 7.4 AML obligations and limits

Finding: AML obligations likely include DNFBP registration/monitoring/reporting, suspicious transaction/reporting workflows and sanctions screening for relevant gaming participants. Specific OX obligations and thresholds were not verified in primary sources.

Status: **LIKELY**

Thresholds: **UNKNOWN** for OX-specific thresholds.

Evidence: [NGA-SCUML-001], [NGA-GAM-001]

## 8. Advertising and affiliates

### 8.1 Global jackpot advertising

Finding: advertising directed at Nigerian users is subject to ARCON requirements; applying those requirements to a global jackpot campaign is likely but still needs gaming-specific review.

Status: **LIKELY**

Evidence: ARCON Act applies to advertisements directed at Nigerian market and requires Standards Panel approval before exposure. [NGA-ARCON-001]

### 8.2 Affiliates, influencers, Telegram and social media

Finding: no gaming-specific source found for Telegram/influencer rules. General advertising controls apply to marketing communications directed at Nigeria.

Status: **UNCLEAR**

Evidence: ARCON Act covers advertising and marketing communications directed at Nigeria, including foreign entities. [NGA-ARCON-001]

### 8.3 Responsible gambling warnings

Finding: responsible gambling warnings are likely required or expected.

Status: **LIKELY**

Evidence: ICLG states responsible gambling requirements are a regulatory focus and licence conditions include responsible gambling controls. [NGA-GAM-001]

## 9. Tax

### 9.1 Gaming taxes

Finding: operators are subject to gaming-related taxes/levies, but exact OX allocation requires local tax advice.

Status: **LIKELY**

Evidence: ICLG discusses gaming taxes and state/federal obligations for gambling operators. [NGA-GAM-001]

### 9.2 GGR tax / turnover tax

Finding: exact GGR vs turnover tax treatment for OX global pool was not verified from primary FIRS/NRS sources.

Status: **UNKNOWN**

Evidence: source gap.

### 9.3 Withholding tax on winnings

Finding: no primary source found confirming withholding on player winnings for this product.

Status: **UNKNOWN**

Evidence: source gap.

### 9.4 VAT/GST on platform fee

Finding: VAT/GST treatment of OX platform fee and B2B services is unknown from retrieved primary sources.

Status: **UNKNOWN**

Evidence: source gap.

### 9.5 Who pays tax

Finding: local operator likely has direct local gaming tax obligations; OX may have Nigerian tax exposure if paid revenue share/platform fee for Nigerian activity.

Status: **UNCLEAR**

Evidence: general operator tax relevance from ICLG; no OX-specific tax source. [NGA-GAM-001]

## 10. Data protection

### 10.1 Applicable law

Finding: Nigeria Data Protection Act 2023 and NDPC guidance are applicable where Nigerian data subjects are processed or targeted.

Status: **VERIFIED**

Evidence: NDPC website and GAID 2025. [NGA-NDPC-001], [NGA-NDPC-002]

### 10.2 Controller / processor

Finding: local operator is likely controller for player relationship/KYC, but OX may be processor or independent/joint controller depending on its role in risk checks, wallet screening, payout decisions and audit logs. The final role split is fact-specific.

Status: **UNCLEAR**

Evidence: NDPC GAID covers controller/processor obligations and DPA requirements, but role allocation is fact-specific. [NGA-NDPC-002]

### 10.3 Transfer to OX and storage outside Nigeria

Finding: cross-border data transfer is possible only under NDPA/GAID transfer grounds and safeguards.

Status: **VERIFIED**

Evidence: GAID Article 45 and Schedule 5 cover adequacy, Commission-approved instruments and other lawful bases. [NGA-NDPC-002]

## 11. Smart contract and audit

### 11.1 Smart contract settlement

Finding: no gaming source found expressly approving smart-contract settlement for betting payouts in Nigeria.

Status: **UNKNOWN**

Evidence: source gap.

### 11.2 Audit and certification

Finding: software certification and architecture review are likely required; smart-contract audit is prudent and likely expected if smart contracts are part of payout/settlement.

Status: **LIKELY**

Evidence: ICLG licence materials include certified software and software architecture; SEC ARIP mentions smart-contract governance in digital asset context. [NGA-GAM-001], [NGA-SEC-003]

### 11.3 Payout engine certification

Finding: likely product/software certification issue, but exact standard unknown.

Status: **UNCLEAR**

Evidence: [NGA-GAM-001]

### 11.4 Liability for smart contract bugs

Finding: no statutory allocation found. Must be handled in partner agreement and player-facing terms subject to regulator approval.

Status: **UNKNOWN**

Evidence: source gap.

## 12. Player complaints and liability

### 12.1 Who is responsible to player

Finding: local licensed operator may be primary player-facing party if OX follows B2B/B2B2C model, but OX may be co-responsible if it controls settlement, smart contract and pool. The final liability allocation is not established by the sources.

Status: **UNCLEAR**

Evidence: local operator model is an OX assumption; regulator sources do not allocate OX liability. ICLG confirms regulators maintain dispute/enforcement functions. [NGA-GAM-001]

### 12.2 Who handles complaints

Finding: local operator should handle first-line complaints, with escalation to regulator and OX technical support for settlement/oracle/payout disputes.

Status: **LIKELY**

Evidence: ICLG notes regulatory dispute/enforcement structures; SEC digital asset rules also require complaint/dispute handling for digital asset operators. [NGA-GAM-001], [NGA-SEC-002]

### 12.3 Who covers shortfall

Finding: UNKNOWN. Partner agreement must allocate shortfall caused by smart-contract bug, oracle error, operator KYC mistake, liquidity deficiency, tax withholding or regulator freeze.

Status: **UNKNOWN**

Evidence: no source found.

### 12.4 Partner agreement must cover

Status: **LIKELY**

Required clauses:

- licence/approval responsibility;
- product approval and regulator notices;
- player-facing terms;
- global pool or segregated pool election;
- USDC/fiat payment responsibility;
- KYC/AML/sanctions allocation;
- responsible gambling and self-exclusion integration;
- advertising approval and affiliate rules;
- data processing and cross-border transfer;
- smart-contract audit and bug liability;
- oracle/result disputes;
- payout manifest dispute window;
- shortfall and reserve funding;
- tax and reporting;
- suspension/offboarding;
- regulator access/audit.

## 13. Final recommendation

Recommendation: **RESEARCH MORE**. A later **CONDITIONAL GO** should be considered only if local counsel and, where needed, regulators confirm all launch conditions below.

Status: **UNCLEAR**

Minimum launch conditions:

1. Confirm exact federal/state licensing route for the chosen local operator.
2. Confirm whether OX needs direct supplier/software/platform/vendor/remote operator approval.
3. Obtain product approval for SuperExpress 15 mechanics, jackpot, payout formula and software.
4. Do not use global shared pool until regulator/local counsel confirms cross-border pooling.
5. Prepare Nigeria/operator/license-segregated pool architecture as fallback.
6. Do not accept or pay USDC until gambling regulator, SEC/VASP and banking/payment analysis is cleared.
7. If virtual assets remain in scope, obtain SEC/VASP/ARIP advice and wallet screening controls.
8. Put local operator KYC/AML, SCUML, sanctions and suspicious reporting workflow in place.
9. Approve all advertising/jackpot claims through ARCON and gaming compliance.
10. Execute operator agreement covering player complaints, shortfall, data, audit and smart-contract liability.

## 14. Top 10 red flags

1. Global cross-border pool has no clear source support.
2. USDC gambling tickets and payouts have no clear source support.
3. OX controls events, rules, pool, smart contract and payouts, which may undermine pure supplier position.
4. Federal/state regulatory overlap can require multiple approvals.
5. Software certification/architecture review likely applies.
6. Remote Operator Permit risk if OX is viewed as offering gaming facilities.
7. VASP/DAX/DAC risk if OX touches transfers, custody or administration of USDC.
8. Advertising global jackpot requires careful ARCON/gaming approval.
9. Tax treatment of platform fee, winnings and revenue share is unresolved.
10. Smart-contract bug/shortfall liability is not legally allocated by sources found.

## 15. Top 10 questions for local lawyer

1. Can a Nigerian licensed sports betting/lottery operator offer SuperExpress 15 under its existing licence?
2. Does OX need supplier/software/vendor/platform/technical service provider approval?
3. Does OX need Remote Operator Permit if it controls global pool and payout logic but does not face players?
4. Is pool betting/totalisator with sports outcomes permitted for the relevant operator licence?
5. Can Nigerian players join a global pool with non-Nigerian players?
6. Can the operator advertise a global jackpot funded partly by foreign players?
7. Can tickets and winnings be denominated and settled in USDC?
8. Would OX or the operator need VASP/DAX/DAC approval?
9. What tax applies to turnover, GGR/platform fee, revenue share and player winnings?
10. What technical certification/audit is mandatory for smart contract settlement and payout engine?

## 16. Additional sources needed

1. Current official NLRC licensing rules and Remote Operator Permit terms.
2. National Lottery Act 2005 and National Lottery Regulation 2007 official text.
3. Lagos State Lotteries and Gaming Authority Law 2021 official text.
4. Current state regulator rules for the actual local partner's state.
5. CBN VASP banking guidelines and updates.
6. Money Laundering Prevention and Prohibition Act and gaming/DNFBP implementation rules.
7. FIRS/Nigeria Revenue Service guidance on gaming taxes, VAT and withholding.
8. Any guidance on shared liquidity, jackpot pooling or totalisator pools.
9. Any guidance on stablecoins/crypto in gambling.
10. Mandatory testing/certification standards for gaming software and payout systems.
