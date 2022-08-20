# GeometricTheoremProver.jl

| **Pkg Info** | **Build status** | **Documentation** | **Citation** | **Contributing** |
|:------------:|:----------------:|:-----------------:|:------------:|:----------------:|
|[![version][ver-img]][ver-url][![license: MIT][mit-img]](LICENSE)|[![CI][ci-img]][ci-url][![codecov][cov-img]][cov-url]|[![docs-stable][stable-img]][stable-url][![docs-dev][dev-img]][dev-url]|[![zenodo][doi-img]][doi-url]| [![contributions guidelines][contrib-img]][contrib-url]|

<p align="center">
<img src="./docs/src/assets/logo.svg"/>
</p>

## Overview

A Julia package that can prove theorems in Euclidean geometry. Currently, it supports only Ritt-Wu method. For a brief overview check [this video](https://www.youtube.com/watch?v=q_08LE4UOU8) at JuliaCon2022.

## Installation

Install the package with

```julia
julia> using Pkg; Pkg.add("GeometricTheoremProver")
```

then import the package with

```julia
julia> using GeometricTheoremProver
```

now you are ready to go. 

## Documentation

- [**STABLE**][stable-url] -- Documentation of the latest release
- [**DEV**][dev-url] -- Documentation of the current version on main

## Quickstart Example

Let us prove that Apollonius circle theorem. First we state hypothesis and thesis

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

## Contributing

If you spot something strange (something doesn't work or doesn't behave as expected), please open a [bug issue](https://github.com/lucaferranti/GeometricTheoremProver.jl/issues/new?assignees=&labels=bug&template=bug_report.md&title=%5Bbug%5D).

If have an improvement idea (a new feature, a new piece of documentation, an enhancement of an existing feature), you can open a [feature request issue](https://github.com/lucaferranti/GeometricTheoremProver.jl/issues/new?assignees=&labels=enhancement&template=feature_request.md&title=%5Benhancement%5D%3A+).

If you feel like your issue does not fit any of the above mentioned templates (e.g. you just want to ask something), you can also open a [blank issue](https://github.com/lucaferranti/GeometricTheoremProver.jl/issues/new).

Pull requests are also very welcome! For small fixes, feel free to open a PR directly. For bigger changes, it might be wise to open an issue first. Also, make sure to checkout the [contributing guidelines](https://juliaintervals.github.io/GeometricTheoremProver.jl/dev/CONTRIBUTING/).

## Acknowledgement

- **Author**: [Luca Ferranti](https://lucaferranti.github.io)
- **License**: MIT

[ver-img]: https://img.shields.io/github/v/release/lucaferranti/GeometricTheoremProver.jl
[ver-url]: https://github.com/lucaferranti/GeometricTheoremProver.jl/releases

[mit-img]: https://img.shields.io/badge/license-MIT-yellow.svg

[dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[dev-url]: https://lucaferranti.github.io/GeometricTheoremProver.jl/dev

[stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[stable-url]: https://lucaferranti.github.io/GeometricTheoremProver.jl/stable

[ci-img]: https://github.com/lucaferranti/GeometricTheoremProver.jl/workflows/CI/badge.svg
[ci-url]: https://github.com/lucaferranti/GeometricTheoremProver.jl/actions

[cov-img]: https://codecov.io/gh/lucaferranti/GeometricTheoremProver.jl/branch/main/graph/badge.svg?token=EzyZPusnKj
[cov-url]: https://codecov.io/gh/lucaferranti/GeometricTheoremProver.jl

[doi-img]: https://img.shields.io/badge/zenodo-DOI-blue
[doi-url]: https://doi.org/10.5281/zenodo.5879637

[contrib-img]: https://img.shields.io/badge/contributing-guidelines-orange
[contrib-url]: https://juliaintervals.github.io/GeometricTheoremProver.jl/dev/CONTRIBUTING/