# GeometricTheoremProver

[![license: MIT][mit-img]](LICENSE)[![CI][ci-img]][ci-url][![codecov][cov-img]][cov-url][![doc-dev][dev-img]][dev-url]

## Overview

A Julia Package that can prove theorems in Euclidean geometry using the Ritt-Wu method. 

## Quickstart

Install the package with

```julia
julia> using Pkg; Pkg.add("GeometricTheoremProver")
```

then import the package with

```julia
julia> using GeometricTheoremProver
```

now you are ready to prove your first theorem. Let us prove that Apollonius circle theorem. First we state hypothesis and thesis

```julia
hp = @hp begin
    points(A, B, C)
    C := Segment(A, B) ⟂ Segment(A, C)
    M₁ := Midpoint(A, B)
    M₂ := Midpoint(A, C)
    M₃ := Midpoint(B, C)
    H := A ↓ Segment(B, C)
    O := Circle(M₁, M₂, M₃)
end
```

```
POINTS:
------------
A : free
B : free
C : semifree by (1)
M₁ : dependent by (2)
M₂ : dependent by (3)
M₃ : dependent by (4)
H : dependent by (5)
O : dependent by (6)

HYPOTHESIS:
------------
(1) AB ⟂ AC
(2) M₁ ∈ AB ∧ AM₁ ≅ M₁B
(3) M₂ ∈ AC ∧ AM₂ ≅ M₂C
(4) M₃ ∈ BC ∧ BM₃ ≅ M₃C
(5) H ∈ BC ∧ AH ⟂ BC
(6) OM₁ ≅ OM₂ ≅ OM₃
```

```julia
th = @th H ∈ Circle(O, M₁)
```

```
THESIS:
------------
OH ≅ OM₁
```

now the theorem can be proved with the `prove` function

```julia
prove(hp, th)
```

```
Assigned coordinates:
---------------------
A = (0, 0)
B = (u₁, 0)
C = (x₁, u₂)
M₁ = (x₂, x₃)
M₂ = (x₄, x₅)
M₃ = (x₆, x₇)
H = (x₈, x₉)
O = (x₁₀, x₁₁)

Goal 1: success

Nondegeneracy conditions:
-------------------------
u₁ ≠ 0
-u₁² + 2u₁x₁ - u₂² - x₁² ≠ 0
u₂ ≠ 0
4x₂x₅ - 4x₂x₇ - 4x₃x₄ + 4x₃x₆ + 4x₄x₇ - 4x₅x₆ ≠ 0
-2x₃ + 2x₇ ≠ 0
```

## Documentation

- [**DEV**][dev-url] -- Documentation of the current version on main

## Author

- [Luca Ferranti](https://lucaferranti.github.io)

[mit-img]: https://img.shields.io/badge/license-MIT-yellow.svg

[dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[dev-url]: https://lucaferranti.github.io/GeometricTheoremProver.jl/dev

[stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[stable-url]: https://lucaferranti.github.io/GeometricTheoremProver.jl/stable

[ci-img]: https://github.com/lucaferranti/GeometricTheoremProver.jl/workflows/CI/badge.svg
[ci-url]: https://github.com/lucaferranti/GeometricTheoremProver.jl/actions

[cov-img]: https://codecov.io/gh/lucaferranti/GeometricTheoremProver.jl/branch/main/graph/badge.svg?token=EzyZPusnKj
[cov-url]: https://codecov.io/gh/lucaferranti/GeometricTheoremProver.jl