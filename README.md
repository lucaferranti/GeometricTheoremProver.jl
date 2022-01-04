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
C : free
H : dependent by (1)
K : dependent by (2)
T : dependent by (3)
O : dependent by (4)

HYPOTHESIS:
------------
(1) H ∈ BC ∧ AH ⟂ BC
(2) K ∈ AC ∧ BK ⟂ AC
(3) T ∈ AB ∧ CT ⟂ AB
(4) O = AH ∩ BK
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

[cov-img]: https://codecov.io/gh/lucaferranti/GeometricTheoremProver.jl/branch/master/graph/badge.svg
[cov-url]: https://codecov.io/gh/lucaferranti/GeometricTheoremProver.jl
