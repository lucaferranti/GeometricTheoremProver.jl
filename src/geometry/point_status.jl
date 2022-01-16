abstract type PointStatus end

struct Free <: PointStatus end
show(io::IO, ::Free) = print(io, "free")

struct SemiFree <: PointStatus
    eq1::Int
end
show(io::IO, sf::SemiFree) = print(io, "semifree by (", sf.eq1, ")")

struct Dependent <: PointStatus
    eq1::Int
    eq2::Int
end
Dependent(a) = Dependent(a, 0)
function show(io::IO, d::Dependent)
    print(io, "dependent by ($(d.eq1)$(iszero(d.eq2) ? "" : ", $(d.eq2)"))")
end

_update_status(::Free, ::Free) = Free()
_update_status(::Free, s::PointStatus) = s
_update_status(s::PointStatus, ::Free) = s
_update_status(s1::SemiFree, s2::SemiFree) = Dependent(s1.eq1, s2.eq1)

function _update_status(s1::PointStatus, s2::PointStatus)
    throw(ArgumentError("Cannot add statement ($(s2.eq1)) to point already defined as $s1"))
end
