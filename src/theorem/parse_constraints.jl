sym2status(sym, i) = sym in (:∈, :⟂, :∥, :≅) ? SemiFree(i) : Dependent(i)

function _add_point!(dofs, P, s)
    if haskey(dofs, P)
        dofs[P] = _update_status(dofs[P], s)
    else
        dofs[P] = s
    end
end

function _parse_statement!(dofs, intros, ex)
    if ex.head == :(:=)
        newpoint = ex.args[1]
        constr = ex.args[2]
        newstatus = sym2status(constr.args[1], length(intros.args)+1)
        _add_free_points!(dofs, constr)
        _add_point!(dofs, newpoint, newstatus)
        _parse_constraint!(intros, constr, newpoint)
    elseif ex.head == :call && (ex.args[1] in (:Points, :points))
        for P in ex.args[2:end]
            _add_point!(dofs, P, Free())
        end
    end
end

function _parse_constraint!(intros, constr, newpoint=nothing)
    constr = _quotenodify(constr)
    if !isnothing(newpoint) && constr.args[1] in (:↓, :Midpoint, :midpoint, :∩, :Circle, :circle)
         insert!(constr.args, 2, QuoteNode(newpoint))
    end
    push!(intros.args, constr)
end

function _add_free_points!(dofs, ex::Expr)
    for s in ex.args[2:end]
        _add_free_points!(dofs, s)
    end
end

_add_free_points!(dofs, s::Symbol) = _add_point!(dofs, s, Free())

function _quotenodify(ex::Expr)
    for i in 2:length(ex.args)
        ex.args[i] = _quotenodify(ex.args[i])
    end
    return ex
end

_quotenodify(s::Symbol) = QuoteNode(s)
