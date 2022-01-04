abstract type GeometricStatement end

struct Hypothesis <: GeometricStatement
    points::OrderedDict{Symbol, PointStatus}
    constraints::Vector{GeometricConstraint}
end

function show(io::IO, hp::Hypothesis)
    println(io, "POINTS:")
    println(io, "------------")
    for (p, s) in hp.points
        println(io, p, " : ", s)
    end
    println(io, "")
    println(io, "HYPOTHESIS:")
    println(io, "------------")
    for (i, c) in enumerate(hp.constraints)
        println(io, "(", i, ") ", c)
    end
end


struct Thesis <: GeometricStatement
    constraints::Vector{GeometricConstraint}
end

function show(io::IO, th::Thesis)
    println(io, "THESIS:")
    println(io, "------------")
    for c in th.constraints
        println(io, c)
    end
end

# macros
"""
    @hp(block)

macro to construct the hypothesis of the theorem.

### Input

block -- An expression containing the hypothesis of the theorem, can be a single statement
         or a sequence of statements between `begin...end`.

### Output

An object of type `Hypothesis`.

### Examples

```jldoctest
julia> @hp O := Circle(A, B, C)
POINTS:
------------
A : free
B : free
C : free
O : dependent by (1)

HYPOTHESIS:
------------
(1) OA ≅ OB ≅ OC
```
"""
macro hp(block)
    _parse_hp(block)
end

"""
    @th(block)

macro to construct the thesis of the theorem.

### Input

block -- An expression containing the thesis of the theorem, can be a single statement
         or a sequence of statements between `begin...end`.

### Output

An object of type `Thesis`.

### Examples

```jldoctest
julia> @th Segment(A, O) ≅ Segment(O, C)
THESIS:
------------
AO ≅ OC
```
"""
macro th(block)
    _parse_th(block)
end

#####################
## Prover interface #
#####################

abstract type AbstractGeometricProver end
abstract type AbstractGeometricProof end

"""
    prove(hp::Hypothesis, th::Thesis[, method=RittWuMethod])

Proves a thereom with given hypothesis `hp` and thesis `th`.

### Input

- `hp::Hypothesis`                  -- hypothesis of the theorem
- `th::Thesis`                      -- thesis of the theorem
- `method<:AbstractGeometricProver` -- method to prove the theorem, default `RittWuMethod`.

### Output

A proof of the the theorem. The type of the output depends on the chosen method

### Algorithms

Currently the following provers are supported

- RittWuMethod

### Examples

# TODO: ADD EXAMPLE

"""
prove(hp::Hypothesis, th::Thesis) = prove(hp, th, RittWuMethod)
