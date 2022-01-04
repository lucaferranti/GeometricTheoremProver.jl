function algebry(rel::Parallelism, coords)
    A = coords[rel.l.l]
    B = coords[rel.l.r]
    C = coords[rel.r.l]
    D = coords[rel.r.r]
    return ((B.x - A.x)*(D.y - C.y) - (B.y - A.y)*(D.x - C.x),)
end

function algebry(rel::Perpendicularity, coords)
    A = coords[rel.l.l]
    B = coords[rel.l.r]
    C = coords[rel.r.l]
    D = coords[rel.r.r]
    return ((B.x - A.x)*(D.x - C.x) + (B.y - A.y)*(D.y - C.y),)
end

function algebry(rel::Congruence{Segment}, coords)
    A = coords[rel.l.l]
    B = coords[rel.l.r]
    C = coords[rel.r.l]
    D = coords[rel.r.r]
    return ((B.x-A.x)^2 + (B.y-A.y)^2 - (D.x-C.x)^2 - (D.y-C.y)^2,)
end

function algebry(rel::Parallelogram, coords)
    A = coords[rel.A]
    B = coords[rel.B]
    C = coords[rel.C]
    D = coords[rel.D]
    return (B.x + D.x - A.x - C.x, B.y + D.y - A.y - C.y)
end

function algebry(rel::Midpoint, coords)
    M = coords[rel.M]
    A = coords[rel.seg.l]
    B = coords[rel.seg.r]
    return (2*M.x-A.x-B.x, 2*M.y-A.y-B.y)
end

function algebry(rel::Appartenence{Segment}, coords)
    P = coords[rel.l]
    A = coords[rel.r.l]
    B = coords[rel.r.r]
    return ((B.x - A.x)*(P.y - A.y) - (B.y - A.y)*(P.x - A.x),)
end

function algebry(rel::Intersection{Segment, Segment}, coords)
    return (algebry(Appartenence(rel.P, rel.l), coords)[1], algebry(Appartenence(rel.P, rel.r), coords)[1])
end

function algebry(rel::Projection, coords)
    return (algebry(Appartenence(rel.H, rel.seg), coords)[1], algebry(Perpendicularity(Segment(rel.P, rel.H), rel.seg), coords)[1])
end

function algebry(rel::Appartenence{Circle}, coords)
    OP = Segment(rel.r.O, rel.l)
    OA = Segment(rel.r.O, rel.r.A)
    return algebry(Congruence(OA, OP), coords)
end

function algebry(rel::CircleThreePoints, coords)
    OA = Segment(rel.O, rel.A)
    OB = Segment(rel.O, rel.B)
    OC = Segment(rel.O, rel.C)
    return (algebry(Congruence(OA, OB), coords)[1], algebry(Congruence(OA, OC), coords)[1])
end
