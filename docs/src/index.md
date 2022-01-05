# GeometricTheoremProver

[![license: MIT](https://img.shields.io/badge/license-MIT-yellow.svg)](../../LICENSE)[![CI](https://github.com/lucaferranti/GeometricTheoremProver.jl/workflows/CI/badge.svg)](https://github.com/lucaferranti/GeometricTheoremProver.jl/actions)[![codecov](https://codecov.io/gh/lucaferranti/GeometricTheoremProver.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/lucaferranti/GeometricTheoremProver.jl)

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
        M₂ := Midpoint(B, C)
        M₃ := Midpoint(A, C)
        O := Circle(M₁, M₂, M₃)
        H := A ↓ Segment(B, C)
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
O : dependent by (5)
H : dependent by (6)

HYPOTHESIS:
------------
(1) AB ⟂ AC
(2) M₁ ∈ AB ∧ AM₁ ≅ M₁B
(3) M₂ ∈ BC ∧ BM₂ ≅ M₂C
(4) M₃ ∈ AC ∧ AM₃ ≅ M₃C
(5) OM₁ ≅ OM₂ ≅ OM₃
(6) H ∈ BC ∧ AH ⟂ BC
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
B = (u[1], 0)
C = (x[1], u[2])
M₁ = (x[2], x[3])
M₂ = (x[4], x[5])
M₃ = (x[6], x[7])
O = (x[8], x[9])
H = (x[10], x[11])

Goal 1: success
```

## Author

- [Luca Ferranti](https://lucaferranti.github.io)