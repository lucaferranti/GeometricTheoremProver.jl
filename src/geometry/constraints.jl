abstract type GeometricConstraint end

struct Parallelism <: GeometricConstraint
    l::Segment
    r::Segment
end
const ∥ = Parallelism

struct Perpendicularity <: GeometricConstraint
    l::Segment
    r::Segment
end
const ⟂ = Perpendicularity

struct Congruence{T<:GeometricEntity} <: GeometricConstraint
    l::T
    r::T
end
const ≅ = Congruence

struct Appartenence{T<:GeometricEntity} <: GeometricConstraint
    l::Symbol
    r::T
end
Base.:∈(P::Symbol, obj::GeometricEntity) = Appartenence(P, obj)

for (op, sym) in [(Parallelism, :∥), (Perpendicularity, :⟂), (Congruence, :≅), (Appartenence{Segment}, :∈)]
    @eval show(io::IO, rel::$op) = print(io, rel.l, " ", $(QuoteNode(sym)), " ", rel.r)
end

show(io::IO, rel::Appartenence{Circle}) = print(io, rel.r.O, rel.l, " ≅ ", rel.r.O, rel.r.A)

struct Intersection{T <: GeometricEntity, S <: GeometricEntity} <: GeometricConstraint
    P::Symbol
    l::T
    r::S
end
const ∩ = Intersection

show(io::IO, rel::Intersection) = print(io, rel.P, " = ", rel.l, " ∩ ", rel.r)

struct Midpoint <: GeometricConstraint
    M::Symbol
    seg::Segment
end
Midpoint(M, A, B) = Midpoint(M, Segment(A, B))
const midpoint = Midpoint

show(io::IO, rel::Midpoint) = print(io, rel.M, " ∈ ", rel.seg, " ∧ ", rel.seg.l, rel.M, " ≅ ", rel.M, rel.seg.r)

struct Parallelogram <: GeometricConstraint
    A::Symbol
    B::Symbol
    C::Symbol
    D::Symbol
end
const parallelogram = Parallelogram
show(io::IO, rel::Parallelogram) = print(io, rel.A, rel.B, rel.C, rel.D, " parallelogram")

struct Projection <: GeometricConstraint
    H::Symbol
    P::Symbol
    seg::Segment
end
const ↓ = Projection
show(io::IO, rel::Projection) = print(io, rel.H, " ∈ ", rel.seg, " ∧ ", rel.P, rel.H, " ⟂ ", rel.seg)

struct CircleThreePoints <: GeometricConstraint
    O::Symbol
    A::Symbol
    B::Symbol
    C::Symbol
end
show(io::IO, rel::CircleThreePoints) = print(io, rel.O, rel.A, " ≅ ", rel.O, rel.B, " ≅ ", rel.O, rel.C)
Circle(O, A, B, C) = CircleThreePoints(O, A, B, C)
