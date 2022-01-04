function LC(p, var)
    d = maxdegree(p, var)
    d == 0 && return zero(p)
    return polynomial([subs(t, var => 1) for t in terms(p) if degree(t, var) == d])
end

function pseudorem(f, g, y)
    r = f
    lc = LC(g, y)
    m = maxdegree(g, y)
    d = maxdegree(r, y)

    while d ≥ m && !iszero(r)
        r = lc * r - LC(r, y) * g * y ^ (d - m)
        d = maxdegree(r, y)
    end

    return r
end

function triangulize(H, vars)
    n = length(H)

    T = similar(H)
    @inbounds for i = n:-1:1
        degrees = Int[] # degrees of polynomials in C
        indeces = Int[] # indeces in H of polynomials in C

        # initialize
        @inbounds for (idx, p) in enumerate(H)
            deg = maxdegree(p, vars[i])
            if deg > 0
                push!(degrees, deg)
                push!(indeces, idx)
            end
        end

        # If there are several polynomials in C but none has degree 1 in x, transform the
        # set until there is a polynomial of degree 1 or only one polynomial is left
        C = H[indeces]
        while minimum(degrees) > 1 && length(C) > 1
            _, idx_max = findmax(degrees)
            _, idx_min = findmin(degrees)

            # special case when all  have same degree
            if idx_max == idx_min
                idx_min = 1
                idx_max = 2
            end

            r = pseudorem(C[idx_max], C[idx_min], vars[i])
            d = maxdegree(r, vars[i])
            if iszero(d)
                H[indeces[idx_max]] = r
                deleteat!(C, idx_max)
                deleteat!(degrees, idx_max)
                deleteat!(indeces, idx_max)
            else
                C[idx_max] = r
                degrees[idx_max] = d
            end
        end

        # if only one polynomial in C, add to triangular set and go to the next variable
        if length(indeces) == 1
            T[i] = H[indeces[1]]
            deleteat!(H, indeces[1])
            continue
        end

        # if multiple polynomials but at least one has degree 1, add this to triangular set
        # and replace the others in H with the pseudoremainder
        idx = findlast(==(1), degrees)
        if !isnothing(idx)
            pivot = H[indeces[idx]]
            T[i] = pivot
            #pushfirst!(T, pivot)

            @inbounds for j in indeces
                if j != indeces[idx]
                    H[j] = pseudorem(H[j], pivot, vars[i])
                end
            end
            deleteat!(H, indeces[idx])
            continue
        end

    end
    return T
end
