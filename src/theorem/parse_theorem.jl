function _parse_hp(block)
    dofs = OrderedDict{Symbol, PointStatus}()
    intros = :([])

    if block.head == :block
        for ex in block.args
            if ex isa Expr
                _parse_statement!(dofs, intros, ex)
            end
        end
    else
        _parse_statement!(dofs, intros, block)
    end
    return :(Hypothesis($dofs, $intros))
end

function _parse_th(block)
    th = :([])

    if block.head == :block
        for ex in block.args
            if ex isa Expr
                _parse_constraint!(th, ex)
            end
        end
    else
        if block isa Expr
            _parse_constraint!(th, block)
        end
    end

    return :(Thesis($th))
end
