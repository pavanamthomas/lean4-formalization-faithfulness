import FormalizationFaithfulness.DomainTraps

/-!
# Logical-structure traps

These cases isolate quantifier dependency, uniqueness, vacuity, dropped predicates,
and strength drift. They are deliberately small so the semantic failure is auditable.
-/

namespace FormalizationFaithfulness

/-! ## Case 08 — quantifier inversion can trivialize a maximum statement -/

/-- This bad shape is true on *every* set and for *every* real-valued function. -/
theorem pairwiseDominated_trivial (s : Set ℝ) (f : ℝ → ℝ) :
    PairwiseDominatedOn s f := by
  intro y hy
  exact ⟨y, hy, le_rfl⟩

/-- The bad version even holds on `(0,1)` for the identity function... -/
theorem badExtremeValue_holds_on_openInterval :
    PairwiseDominatedOn (Set.Ioo (0 : ℝ) 1) (fun x : ℝ => x) := by
  exact pairwiseDominated_trivial _ _

/-- ...while the faithful one-witness maximum statement fails there. -/
theorem faithfulExtremeValue_fails_on_openInterval :
    ¬ HasMaximumOn (Set.Ioo (0 : ℝ) 1) (fun x : ℝ => x) := by
  exact identity_openInterval_noMaximum

/-! ## Case 09 — `∀ x, ∃ y` is not `∃ y, ∀ x` -/

theorem forallExists_identity : ∀ x : ℕ, ∃ y : ℕ, y = x := by
  intro x
  exact ⟨x, rfl⟩

theorem not_existsForall_identity : ¬ ∃ y : ℕ, ∀ x : ℕ, y = x := by
  rintro ⟨y, hy⟩
  have h0 : y = 0 := hy 0
  have h1 : y = 1 := hy 1
  omega

/-! ## Case 10 — existence and unique existence are different claims -/

theorem squareOne_exists : ∃ x : ℝ, x ^ 2 = 1 := by
  exact ⟨1, by norm_num⟩

theorem squareOne_notUnique : ¬ ∃! x : ℝ, x ^ 2 = 1 := by
  rintro ⟨x, hx, huniq⟩
  have hpos : (1 : ℝ) ^ 2 = 1 := by norm_num
  have hneg : (-1 : ℝ) ^ 2 = 1 := by norm_num
  have hxPos : (1 : ℝ) = x := huniq 1 hpos
  have hxNeg : (-1 : ℝ) = x := huniq (-1) hneg
  linarith

/-! ## Case 11 — contradictory premises can make a theorem vacuously true -/

def VacuousClaim : Prop := ∀ x : ℝ, x < x → x = 37

theorem vacuousClaim_isProvable : VacuousClaim := by
  intro x hx
  exact (lt_irrefl x hx).elim

/-! ## Case 12 — dropping a predicate can leave a trivially provable but unfaithful theorem -/

theorem badGoldbachWitness_trivial (n : ℕ) : BadGoldbachWitness n := by
  exact ⟨0, n, by simp⟩

/-- At `n = 1`, the weakened predicate is true while the prime-witness predicate is false. -/
theorem droppedPrimality_changes_truth :
    BadGoldbachWitness 1 ∧ ¬ FaithfulGoldbachWitness 1 := by
  constructor
  · exact badGoldbachWitness_trivial 1
  · rintro ⟨p, q, hp, hq, hsum⟩
    have hp2 : 2 ≤ p := hp.two_le
    have hq2 : 2 ≤ q := hq.two_le
    omega

/-! ## Case 13 — upper bound versus attained maximum -/

theorem one_isUpperBound_on_openInterval :
    IsUpperBoundOn (Set.Ioo (0 : ℝ) 1) (fun x : ℝ => x) 1 := by
  intro x hx
  exact le_of_lt hx.2

/-- Having an upper bound does not imply that the upper bound is attained. -/
theorem upperBound_doesNotImplyMaximum :
    IsUpperBoundOn (Set.Ioo (0 : ℝ) 1) (fun x : ℝ => x) 1 ∧
      ¬ HasMaximumOn (Set.Ioo (0 : ℝ) 1) (fun x : ℝ => x) := by
  exact ⟨one_isUpperBound_on_openInterval, identity_openInterval_noMaximum⟩

/-! ## Bonus — implication scope is semantic, not cosmetic -/

theorem implicationScope_counterexample :
    (False → False ∧ False) ∧ ¬ ((False → False) ∧ False) := by
  simp

end FormalizationFaithfulness
