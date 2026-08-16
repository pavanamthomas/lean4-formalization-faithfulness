import FormalizationFaithfulness.LogicTraps

/-!
# Reviewer-style cases

These are written as review records for candidate statement/proof pairs:
identify the semantic defect, repair it, and give a concrete regression test.
-/

namespace FormalizationFaithfulness

/-! ## Case 14 — compactness can give existence, not automatic uniqueness -/

/-- A constant function on `[0,1]` has many maximizers, so a unique-max claim is false. -/
theorem constantFunction_uniqueMaximum_false :
    ¬ HasUniqueMaximumOn (Set.Icc (0 : ℝ) 1) (fun _ : ℝ => 0) := by
  rintro ⟨x, hx, huniq⟩
  have h0 : (0 : ℝ) ∈ Set.Icc (0 : ℝ) 1 ∧
      ∀ y ∈ Set.Icc (0 : ℝ) 1, (0 : ℝ) ≤ 0 := by
    constructor
    · constructor <;> norm_num
    · intro y hy
      norm_num
  have h1 : (1 : ℝ) ∈ Set.Icc (0 : ℝ) 1 ∧
      ∀ y ∈ Set.Icc (0 : ℝ) 1, (0 : ℝ) ≤ 0 := by
    constructor
    · constructor <;> norm_num
    · intro y hy
      norm_num
  have hx0 : (0 : ℝ) = x := huniq 0 h0
  have hx1 : (1 : ℝ) = x := huniq 1 h1
  linarith

/-- Corrected existence claim for the same example. -/
theorem constantFunction_hasMaximum :
    HasMaximumOn (Set.Icc (0 : ℝ) 1) (fun _ : ℝ => 0) := by
  refine ⟨0, ?_, ?_⟩
  · constructor <;> norm_num
  · intro y hy
    norm_num

/-! ## Case 15 — “infinitely many” must encode non-finiteness/unbounded supply, not repeated existence -/

/-- Bad formalization: the same prime can be reused for every input. -/
def BadInfinitelyManyPrimes : Prop := ∀ n : ℕ, ∃ p : ℕ, Nat.Prime p

theorem badInfinitelyManyPrimes_trivial : BadInfinitelyManyPrimes := by
  intro _n
  exact ⟨2, Nat.prime_two⟩

/-- Canonical mathlib statement of infinitude of the set of primes. -/
theorem primes_areInfinite : {p : ℕ | Nat.Prime p}.Infinite := by
  exact Nat.infinite_setOfPred_prime

/-! ## Positive canonicalization example — prefer the library predicate for irrationality -/

theorem sqrtTwo_isIrrational : Irrational (Real.sqrt 2) := by
  exact irrational_sqrt_two

/-! ## Reviewer records: explicit defect → repair → validation -/

def case01_review : ReviewRecord := {
  verdict := .fatalSemanticError
  issue := "The statement quantifies over x = 0, where x / x is not 1."
  repair := "Add x ≠ 0 before asserting x / x = 1."
  validation := "Instantiate the naive universal claim at x = 0."
}

def case08_review : ReviewRecord := {
  verdict := .fatalSemanticError
  issue := "The witness x is chosen after y, so x := y trivializes the claim."
  repair := "Move the existential witness outside the universal quantifier over y."
  validation := "Test the identity function on the open interval (0,1): the bad claim holds, the maximum claim fails."
}

def case14_review : ReviewRecord := {
  verdict := .majorFormalizationError
  issue := "The source overclaims uniqueness; compactness/continuity alone do not give a unique maximizer."
  repair := "State existence of a maximizer unless a separate uniqueness condition is available."
  validation := "Use a constant function on [0,1], where every point is a maximizer."
}

end FormalizationFaithfulness
