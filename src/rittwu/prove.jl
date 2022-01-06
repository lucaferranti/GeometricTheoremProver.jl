struct RittWuMethod <: AbstractGeometricProver end

mutable struct RittWuProof{S} <: AbstractGeometricProof
    coords::OrderedDict{Symbol, Coordinate}
    H::Vector{S}
    T::Vector{S}
    R::Matrix{S}
    u::Vector{PolyVar{true}}
    x::Vector{PolyVar{true}}
end

function show(io::IO, rwp::RittWuProof)
    println(io, "Assigned coordinates:")
    println(io, "---------------------")
    for (P, c) in rwp.coords
        println(io, P, " = ", c)
    end
    println("")
    for (idx, p) in enumerate(eachcol(rwp.R))
        status = iszero(first(p)) ? "success" : "fail"
        println(io, "Goal $idx: $status")
    end
end

function prove(hp::Hypothesis, th::Thesis, ::Type{RittWuMethod})
    coords, x, u = assign_variables(hp)
    H = [cc for c in hp.constraints for cc in algebry(c, coords)]
    G = [cc for c in th.constraints for cc in algebry(c, coords)]
    T = triangulize(copy(H), x)

    R = Matrix{eltype(T)}(undef, length(x) + 1, length(G))
    @inbounds for (idx, g) in enumerate(G)
        R[end, idx] = g
        @inbounds for i in length(x):-1:1
            R[i, idx] = pseudorem(R[i+1, idx], T[i], x[i])
        end
    end

    return RittWuProof(coords, H, T, R, u, x)
end

isproved(rwp::RittWuProof) = [iszero(first(p)) for p in eachcol(rwp.R)]
