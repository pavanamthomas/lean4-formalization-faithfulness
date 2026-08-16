# Case Index

| Case | Failure class | Core artifact |
|---|---|---|
| 01 | Missing nonzero hypothesis | `NaiveSelfDivision` / `selfDivision_repaired` |
| 02 | Square-root sign/domain drift | `NaiveSqrtSquare` / `sqrtSquare_canonical` |
| 03 | Log/exp domain mismatch | `NaiveExpLog` / `expLog_repaired` |
| 04 | `Nat` subtraction truncation | `natSubtraction_truncates` |
| 05 | Coercion placement changes semantics | `coercionPlacement_changes_semantics` |
| 06 | Open vs closed domain / attainment | `identity_openInterval_noMaximum` |
| 07 | Empty-set extremum | `emptySet_hasNoMaximum` |
| 08 | Quantifier inversion / trivialization | `pairwiseDominated_trivial` |
| 09 | `∀∃` vs `∃∀` dependency | `forallExists_identity` / `not_existsForall_identity` |
| 10 | Existence vs unique existence | `squareOne_notUnique` |
| 11 | Vacuous truth | `vacuousClaim_isProvable` |
| 12 | Dropped predicate | `droppedPrimality_changes_truth` |
| 13 | Upper bound vs maximum | `upperBound_doesNotImplyMaximum` |
| 14 | Unjustified uniqueness | `constantFunction_uniqueMaximum_false` |
| 15 | Infinitude quantifier collapse | `BadInfinitelyManyPrimes` / `primes_areInfinite` |
| Bonus | Implication scope | `implicationScope_counterexample` |
| Positive | Canonical mathlib predicate | `sqrtTwo_isIrrational` |
