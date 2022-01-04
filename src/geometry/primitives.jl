abstract type GeometricEntity end

struct Segment <: GeometricEntity
    l::Symbol
    r::Symbol
end
show(io::IO, AB::Segment) = print(io, AB.l, AB.r)
const segment = Segment

struct Circle <: GeometricEntity
    O::Symbol
    A::Symbol
end
show(io::IO, γ::Circle) = print(io, "circle center ", γ.O, " radius ", γ.O, γ.A)
const circle = Circle
