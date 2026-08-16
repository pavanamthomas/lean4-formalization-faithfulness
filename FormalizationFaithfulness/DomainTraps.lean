import FormalizationFaithfulness.Core

/-!
# Domain and representation traps

Each case contains:
1. an informal-source failure mode,
2. a bad formalization or counterexample,
3. a corrected Lean statement,
4. a validation argument.
-/

namespace FormalizationFaithfulness

/-! ## Case 01 — division by self needs a nonzero hypothesis -/

def NaiveSelfDivision : Prop := ∀ x : ℝ, x / x = 1

theorem naiveSelfDivision_false : ¬ NaiveSelfDivision := by
  intro h
  have h0 : (0 : ℝ) / 0 = 1 := h 0
  norm_num at h0

/-- Faithful repair: exclude the totalized junk case `x = 0`. -/
theorem selfDivision_repaired (x : ℝ) (hx : x ≠ 0) : x / x = 1 := by
  exact div_self hx

/-! ## Case 02 — `sqrt (x^2) = x` silently assumes `0 ≤ x` -/

def NaiveSqrtSquare : Prop := ∀ x : ℝ, Real.sqrt (x ^ 2) = x

theorem naiveSqrtSquare_false : ¬ NaiveSqrtSquare := by
  intro h
  have hneg : Real.sqrt ((-1 : ℝ) ^ 2) = (-1 : ℝ) := h (-1)
  norm_num at hneg

/-- Canonical total statement: the square root of a square is an absolute value. -/
theorem sqrtSquare_canonical (x : ℝ) : Real.sqrt (x ^ 2) = |x| := by
  exact Real.sqrt_sq_eq_abs x

/-- If the source really intends `x`, nonnegativity is load-bearing. -/
theorem sqrtSquare_repaired (x : ℝ) (hx : 0 ≤ x) : Real.sqrt (x ^ 2) = x := by
  exact Real.sqrt_sq hx

/-! ## Case 03 — `exp (log x) = x` needs positivity for the real logarithm -/

def NaiveExpLog : Prop := ∀ x : ℝ, Real.exp (Real.log x) = x

theorem naiveExpLog_false : ¬ NaiveExpLog := by
  intro h
  have hbad : Real.exp (Real.log (-1 : ℝ)) = (-1 : ℝ) := h (-1)
  have hgood : Real.exp (Real.log (-1 : ℝ)) = 1 := by
    have hne : (-1 : ℝ) ≠ 0 := by norm_num
    simpa using (Real.exp_log_eq_abs (x := (-1 : ℝ)) hne)
  rw [hgood] at hbad
  norm_num at hbad

/-- Faithful repair for the ordinary inverse relationship between `exp` and `log`. -/
theorem expLog_repaired (x : ℝ) (hx : 0 < x) : Real.exp (Real.log x) = x := by
  exact Real.exp_log hx

/-! ## Case 04 — natural-number subtraction truncates -/

theorem natSubtraction_truncates : (2 : ℕ) - 5 = 0 := by
  norm_num

theorem integerSubtraction_expected : (2 : ℤ) - 5 = -3 := by
  norm_num

/-- A standard repair if the intended domain really is `ℕ`. -/
theorem natSubtraction_repaired (a b : ℕ) (hba : b ≤ a) : a - b + b = a := by
  omega

/-! ## Case 05 — coercing after `Nat` subtraction is not the same as subtracting after coercion -/

theorem castAfterNatSubtraction : (↑((2 : ℕ) - 5) : ℤ) = 0 := by
  norm_num

theorem subtractAfterCast : (↑(2 : ℕ) : ℤ) - 5 = -3 := by
  norm_num

theorem coercionPlacement_changes_semantics :
    (↑((2 : ℕ) - 5) : ℤ) ≠ (↑(2 : ℕ) : ℤ) - 5 := by
  norm_num

/-! ## Case 06 — open versus closed domain changes attainment -/

/-- The identity function attains its maximum on the closed interval `[0,1]`. -/
theorem identity_closedInterval_hasMaximum :
    HasMaximumOn (Set.Icc (0 : ℝ) 1) (fun x : ℝ => x) := by
  refine ⟨1, ?_, ?_⟩
  · constructor <;> norm_num
  · intro y hy
    exact hy.2

/-- The same function has no maximum on the open interval `(0,1)`. -/
theorem identity_openInterval_noMaximum :
    ¬ HasMaximumOn (Set.Ioo (0 : ℝ) 1) (fun x : ℝ => x) := by
  rintro ⟨x, hx, hmax⟩
  let y : ℝ := (x + 1) / 2
  have hy0 : 0 < y := by
    simp [y]
    nlinarith [hx.1]
  have hy1 : y < 1 := by
    simp [y]
    nlinarith [hx.2]
  have hxy : x < y := by
    simp [y]
    nlinarith [hx.2]
  have hle : y ≤ x := by
    simpa using hmax y ⟨hy0, hy1⟩
  exact (not_le_of_gt hxy) hle

/-! ## Case 07 — empty-domain extrema need nonemptiness -/

theorem emptySet_hasNoMaximum (f : ℝ → ℝ) :
    ¬ HasMaximumOn (∅ : Set ℝ) f := by
  rintro ⟨x, hx, _⟩
  simpa using hx

end FormalizationFaithfulness
