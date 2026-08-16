import Mathlib

/-!
# Core audit vocabulary

This file defines small reusable predicates used throughout the project.
The project is intentionally about *faithfulness*, not just provability.
-/

namespace FormalizationFaithfulness

/-- A compact reviewer taxonomy for candidate formalizations. -/
inductive ReviewVerdict where
  | correct
  | minorCanonicalityIssue
  | versionOrApiIssue
  | majorProofError
  | majorFormalizationError
  | fatalSemanticError
  deriving Repr, DecidableEq

/-- A lightweight review record: verdict, defect, repair, validation. -/
structure ReviewRecord where
  verdict : ReviewVerdict
  issue : String
  repair : String
  validation : String
  deriving Repr

/-- One point dominates every other point in the set with respect to `f`. -/
def HasMaximumOn (s : Set ℝ) (f : ℝ → ℝ) : Prop :=
  ∃ x ∈ s, ∀ y ∈ s, f y ≤ f x

/-- A common *bad* quantifier pattern: the witness may depend on `y`. -/
def PairwiseDominatedOn (s : Set ℝ) (f : ℝ → ℝ) : Prop :=
  ∀ y ∈ s, ∃ x ∈ s, f y ≤ f x

/-- `M` is merely an upper bound for values of `f` on `s`; attainment is not asserted. -/
def IsUpperBoundOn (s : Set ℝ) (f : ℝ → ℝ) (M : ℝ) : Prop :=
  ∀ x ∈ s, f x ≤ M

/-- A deliberately weakened Goldbach-like witness predicate with primality dropped. -/
def BadGoldbachWitness (n : ℕ) : Prop :=
  ∃ p q : ℕ, p + q = n

/-- The faithful witness predicate for the sum-of-two-primes part of Goldbach. -/
def FaithfulGoldbachWitness (n : ℕ) : Prop :=
  ∃ p q : ℕ, Nat.Prime p ∧ Nat.Prime q ∧ p + q = n

/-- Unique maximizer: both attainment and uniqueness are encoded. -/
def HasUniqueMaximumOn (s : Set ℝ) (f : ℝ → ℝ) : Prop :=
  ∃! x : ℝ, x ∈ s ∧ ∀ y ∈ s, f y ≤ f x

end FormalizationFaithfulness
