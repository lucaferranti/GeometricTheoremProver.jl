struct RittWuMethod <: AbstractGeometricProver end

mutable struct RittWuProof{S} <: AbstractGeometricProof
    coords::OrderedDict{Symbol, Coordinate}
    H::Vector{S}
    T::Vector{S}
    res::Vector{Bool}
end

function show(io::IO, rwp::RittWuProof)
    println(io, "Assigned coordinates:")
    println(io, "---------------------")
    for (P, c) in rwp.coords
        println(io, P, " = ", c)
    end
    println("")
    for (idx, p) in enumerate(rwp.res)
        status = p ? "success" : "fail"
        println(io, "Goal $idx: $status")
    end
end

function prove(hp::Hypothesis, th::Thesis, ::Type{RittWuMethod})
    coords, x = assign_variables(hp)
    H = [cc for c in hp.constraints for cc in algebry(c, coords)]
    G = [cc for c in th.constraints for cc in algebry(c, coords)]
    T = triangulize(copy(H), x)
    res = Vector{Bool}(undef, length(G))
    @inbounds for (idx, g) in enumerate(G)
        R = successive_pseudodivisions(T, g, x)
        res[idx] = iszero(R)
    end
    return RittWuProof(coords, H, T, res)
end

function successive_pseudodivisions(H, g, x)
    R = g
    @inbounds for i in length(H):-1:1
        R = pseudorem(R, H[i], x[i])
    end
    return R
end
