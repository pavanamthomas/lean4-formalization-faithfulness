# Lean 4 Formalization Faithfulness

A self-directed Lean 4 + mathlib study of when a compiled formalization still fails to mean the intended mathematics.

## Purpose

A Lean theorem can be kernel-correct and still mistranslate the source claim. This repository studies the difference between:

1. **Kernel/type correctness** — Lean accepts the statement and the proof.
2. **Statement faithfulness** — the formal proposition is the intended mathematical claim, not a weaker, stronger, vacuous, or domain-shifted cousin.
3. **Proof faithfulness** — the proof establishes that intended claim rather than exploiting a defective translation.

Each core case pairs an informal intent with a tempting but unfaithful formalization, a diagnosis, a repaired statement, a proof, and a regression test.

This repository is a self-directed Lean 4 and mathlib formalization study.

## Topics covered

- hidden assumptions
- division by zero
- inverse/domain restrictions
- square-root domain behavior
- logarithm domain behavior
- natural-number subtraction
- coercion placement
- quantifier inversion
- vacuous truth
- existence versus unique existence
- empty domains
- open versus closed intervals
- maximum versus upper bound
- dropped predicates
- statement-strength drift
- canonical mathlib representations
- formalization review

## Repository structure

```text
.
├── FormalizationFaithfulness.lean
├── FormalizationFaithfulness/
│   ├── Core.lean              reusable predicates and review vocabulary
│   ├── DomainTraps.lean       cases 01–07: domain, types, totalized operations
│   ├── LogicTraps.lean        cases 08–13 plus implication-scope
│   ├── ReviewerCases.lean     cases 14–15, Irrational, review records
│   └── TrustAudit.lean        #print axioms dependency inspection
├── AUDIT_CHECKLIST.md         review checklist used throughout the study
├── CASE_INDEX.md              map from cases to Lean names
├── scripts/
│   ├── check_no_sorry.sh      reject sorry / admit in Lean sources
│   └── build_and_check.sh     placeholder check, cache, and build
├── .github/workflows/ci.yml
├── lakefile.toml
└── lean-toolchain
```

## Representative cases

**Division by zero.** Field division in Lean is total. `∀ x : ℝ, x / x = 1` is false because the `x = 0` case fails. The repaired theorem requires `x ≠ 0`.

**Square root of a square.** `Real.sqrt (x ^ 2) = x` silently assumes nonnegativity. The canonical identity is `Real.sqrt (x ^ 2) = |x|`.

**Logarithm and exponential.** `Real.exp (Real.log x) = x` is the ordinary inverse law only for `0 < x`. Negative inputs leave the real logarithm’s intended domain.

**Natural subtraction and coercion.** On `ℕ`, `2 - 5 = 0`. Casting after subtraction is not the same as subtracting after the cast to `ℤ`.

**Open versus closed intervals.** The identity function attains a maximum on `[0, 1]` and has none on `(0, 1)`. Boundedness does not imply attainment.

**Quantifier inversion.** `∀ y ∈ s, ∃ x ∈ s, f y ≤ f x` is true for every function on every set by taking `x := y`. A maximum requires one common witness.

**Existence versus uniqueness.** `∃ x, x^2 = 1` is true; `∃! x, x^2 = 1` is false. Compactness does not by itself give a unique maximizer.

**Dropped predicates.** Removing primality from a Goldbach-style witness makes the claim true for every `n` by `0 + n`.

**Infinitude of primes.** `∀ n, ∃ p, Nat.Prime p` can reuse the same prime. The faithful claim is that the set of primes is infinite.

See `CASE_INDEX.md` for the full list, including vacuous truth, empty-set extrema, upper bounds versus maxima, and implication-binder scope.

## Build instructions

The project is pinned to **Lean 4.33.0** and **mathlib v4.33.0**. See `lean-toolchain` and `lakefile.toml`.

Install [elan](https://github.com/leanprover/elan), then from the repository root:

```bash
lake update
lake exe cache get
lake build
```

To also reject `sorry` / `admit` placeholders:

```bash
./scripts/build_and_check.sh
```

GitHub Actions runs `scripts/check_no_sorry.sh` and then `leanprover/lean-action@v1` with `build: true`. `nanoda` is not enabled (`nanoda: false` in `.github/workflows/ci.yml`). Placeholder rejection is the shell script, not nanoda.

## Review methodology

Before treating a statement/proof pair as correct:

**Meaning**
→ **Types**
→ **Assumptions**
→ **Quantifiers**
→ **Domain conditions**
→ **Canonical Lean representation**
→ **Proof**
→ **Edge-case test**
→ **Semantic re-audit**

The same workflow is expanded in `AUDIT_CHECKLIST.md`. Compilation is the beginning of validation, not the end.

## Scope

This repository is a self-directed Lean 4 and mathlib formalization study. It demonstrates theorem design, semantic review, and reproducible proof engineering.
