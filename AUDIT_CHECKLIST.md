# Formalization Faithfulness Audit Checklist

Use this before calling a statement/proof pair “correct”.

**Workflow:** Meaning → Types → Assumptions → Quantifiers → Domain conditions → Canonical Lean representation → Proof → Edge-case test → Semantic re-audit.

## 1. Intended meaning
- What exactly does the prose claim?
- Are there ambiguous words such as “the”, “a”, “maximum”, “root”, or “inverse”?

## 2. Types and domains
- Are the objects in `ℕ`, `ℤ`, `ℚ`, `ℝ`, `Set α`, `Finset α`, or a more general structure?
- Does the chosen type change subtraction, division, coercions, or boundary behavior?

## 3. Hypotheses
- Are all explicit and implicit side conditions present?
- Are the hypotheses jointly satisfiable?
- Are nonzero, positivity, nonnegativity, nonemptiness, compactness, or continuity assumptions needed?

## 4. Quantifiers and dependency
- Is `∀ x, ∃ y` being confused with `∃ y, ∀ x`?
- Does a witness incorrectly depend on a later variable?
- Has `∃` been weakened from `∃!` or vice versa?

## 5. Totalized operations
Check `0`, negative arguments, and boundary cases for:
- division `/`
- inverse `⁻¹`
- `Real.sqrt`
- `Real.log`

## 6. Strength and attainment
- Is “maximum” being weakened to “upper bound”?
- Is a closed domain silently replaced by an open one?
- Is uniqueness being claimed without a uniqueness mechanism?

## 7. Proof and trust
- Does the proof establish the intended statement, or a degenerate cousin?
- Are exact theorem names verified against the pinned mathlib revision?
- When relevant, inspect `#print axioms`.

## 8. Adversarial regression test
Try at least one of:
- `0`, `1`, `-1`
- empty set / singleton
- boundary point
- constant function
- identity function
- smallest natural-number cases

A high-quality reviewer should be able to name the specific counterexample or diagnostic, not merely say “check edge cases”.
