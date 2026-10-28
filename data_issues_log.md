# Data Issues Log

Dataset: DOHMH New York City Restaurant Inspection Results (NYC Open Data, 43nn-pn8j)

## Analysis Scope
Cycle Inspection and Pre-permit (Operational) programs, Initial and Re-inspection stages only.

## Found During Exploration (01_explore)

1. **Grain:** one row per violation, not per inspection. Must aggregate before computing inspection-level metrics.
2. **Never-inspected restaurants:** 3,917 rows with INSPECTION DATE = 1900-01-01; ACTION and INSPECTION TYPE also null.
3. **Invalid borough:** BORO = "0" for 311 rows.
4. **Disguised missing coordinates:** some rows have Latitude/Longitude = 0.
5. **Missing ZIP codes** for some rows.
6. **GRADE missing for ~50% of rows** → expected: initial inspections scoring 14+ and non-graded inspection types (e.g., administrative, reopening) receive no grade.
7. **GRADE codes:** N = Not Yet Graded, Z = Grade Pending, P = Grade Pending issued on re-opening after closure.
8. **INSPECTION TYPE combines program and stage** → split into two columns.
9. **Retention rule:** records older than ~3 years before each restaurant's latest inspection are dropped → year-over-year counts are not comparable before 2024.
10. **"No violations" rows flagged Not Critical (186)** → all from Administrative Miscellaneous inspections (codes 18-xx, 19-xx, 20-xx, 28-xx). Administrative, not food safety. Excluded by scope.
11. **"Violations cited" rows flagged Not Applicable (1,807)** → from policy programs (Smoke-Free Air Act, Calorie Posting, Trans Fat, Sodium Warning; codes 15-xx, 16-xx). Not food safety. Excluded by scope.
12. **Grading rule check (initial inspections):** no 14+ score received an A; most 14+ have no grade (as expected). ~4% of 0-13 initial inspections have no grade.
13. **Grade vs. score:** 99.5% of A/B/C grades match the score band. 271 mismatches (0.5%), mostly grade C with score 0-13 (240). Cause unclear (possibly post-adjudication score changes). → Flag as grade_score_mismatch; use SCORE for score-based analysis.

## Found During Cleaning (02_clean)

14. **Coordinates:** 3,085 rows with (0, 0) vs 1,666 true NaN. Total 4,751 rows (1.6%) set to missing; excluded from maps only.
15. **Borough:** 311 rows with "0" → set to missing; 43 filled via ZIP code (flagged boro_imputed). 268 rows (96 restaurants, 0.09%) remain missing: 69 lack ZIP, 199 have ZIPs not found elsewhere.
16. **camis = one physical location:** each camis has exactly one address. Chain brands have multiple camis.
17. **Inconsistent brand names** (e.g., "DUNKIN" vs "DUNKIN'") → standardize before any chain-level analysis.
18. **Hidden categories:** splitting INSPECTION TYPE revealed rare values not seen in earlier head(15) output: "Accelerated Inspection Program" (43 rows) and "Second Compliance Inspection" (295 rows). Both outside scope.
19. **Scope size:** 264,489 rows / 77,125 inspections in scope (~90% of rows).
20. **Exact duplicate rows:** 217 rows in total (206 in scope). All 206 in-scope "repeated violation code within an inspection" cases were exact duplicates → safe to drop (no distinguishing information).
21. **Inspection key validated:** camis + inspection_date + inspection_type uniquely identifies an inspection; score, grade, and action are consistent across all rows of each in-scope inspection.
22. **Grade/score mismatch resolved by scope:** in-scope mismatches drop from 271 to 28 (0.04% of in-scope inspections). Most earlier mismatches were in Reopening/Compliance inspections, which are outside scope.
23. **Restaurant attributes are static:** dba, cuisine, phone, and ZIP never vary across rows for the same camis (likely the dataset uses current info for all rows).
24. **Never-inspected restaurants:** 3,917 restaurants, each with exactly one placeholder row. All lack cuisine; only 2 of 27,452 inspected restaurants lack cuisine.
25. **ACTION text vs. violation count:** 306 inspections have zero violations but non-"No violations" actions (mostly reopenings; 4 in scope); 163 have "No violations" actions but recorded violations (mostly administrative; 9 in scope). 13 in-scope cases (0.02%). → Use n_violations as the source of truth, not ACTION text.