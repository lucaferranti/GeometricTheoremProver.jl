struct Coordinate{T, S}
    x::T
    y::S
end
show(io::IO, c::Coordinate) = print(io, "(", c.x, ", ", c.y, ")")

function compute_num_variables(hp::Hypothesis)
    total_free = 0
    total_dep = 0
    for (P, s) in hp.points
        total_free += numfree(s)
        total_dep += numdep(s)
    end
    return total_free, total_dep
end

numfree(::Free) = 2
numfree(::SemiFree) = 1
numfree(::Dependent) = 0
numdep(::Free) = 0
numdep(::SemiFree) = 1
numdep(::Dependent) = 2

function get_variables(hp::Hypothesis)
    nu, nx = compute_num_variables(hp)
    u, x = @polyvar u[1:nu-3] x[1:nx]
    return u, x
end

function assign_variables(hp::Hypothesis)
    u, x = get_variables(hp)
    point2var = OrderedDict{Symbol, Coordinate}()

    uidx = 1
    xidx = 1
    origin = true
    xaxis = true
    for (P, s) in hp.points
        if s isa Free
            if origin
                point2var[P] = Coordinate(0, 0)
                origin = false
            elseif xaxis
                point2var[P] = Coordinate(u[uidx], 0)
                uidx += 1
                xaxis = false
            else
                point2var[P] = Coordinate(u[uidx], u[uidx+1])
                uidx += 2
            end
        elseif s isa SemiFree
            point2var[P] = Coordinate(u[uidx], x[xidx])
            uidx += 1
            xidx += 1
        elseif s isa Dependent
            point2var[P] = Coordinate(x[xidx], x[xidx+1])
            xidx += 2
        end
    end
    for (P, s) in hp.points
        if s isa SemiFree
            eq = hp.constraints[s.eq1]
            pol = algebry(eq, point2var)[1]
            if maxdegree(pol, point2var[P].y) == 0
                point2var[P] = Coordinate(point2var[P].y, point2var[P].x)
            end
        end
    end
    return point2var, x, u
end
