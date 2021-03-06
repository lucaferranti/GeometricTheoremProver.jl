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
    println(io)
    for (idx, p) in enumerate(eachcol(rwp.R))
        status = iszero(first(p)) ? "success" : "fail"
        println(io, "Goal $idx: $status")
    end
    println(io, "\nNondegeneracy conditions:")
    println(io, "-------------------------")
    for c in ndg(rwp)
        show(io, c)
        println(io, " ≠ 0")
    end
end

function prove(hp::Hypothesis, th::Thesis, ::Type{RittWuMethod}, coords, u, x)
    H = [cc for c in hp.constraints for cc in algebry(c, coords) if !iszero(cc)]
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

function prove(hp::Hypothesis, th::Thesis, ::Type{RittWuMethod})
    coords, x, u = assign_variables(hp)
    return prove(hp, th, RittWuMethod, coords, u, x)
end

isproved(rwp::RittWuProof) = [iszero(first(p)) for p in eachcol(rwp.R)]
ndg(p::RittWuProof) = [LC(t, xi) for (t, xi) in zip(p.T, p.x) if maxdegree(LC(t, xi)) != 0]
