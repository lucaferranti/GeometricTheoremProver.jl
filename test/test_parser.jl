@testset "parse single statement" begin
    free = GTP.Free()
    sf = GTP.SemiFree(1)
    dep = GTP.Dependent(1)

    AB = Segment(:A, :B)
    CD = Segment(:C, :D)

    hp = @hp points(A, B)
    @test isempty(hp.constraints)
    @test hp.points == OrderedDict(:A => free, :B => free)

    hp = @hp Points(A, B, C)
    @test isempty(hp.constraints)
    @test hp.points == OrderedDict(:A => free, :B => free, :C => free)

    hp = @hp P := P ∈ Segment(A, B)
    @test hp.points == OrderedDict(:A => free, :B => free, :P => sf)
    @test hp.constraints == [Appartenence(:P, AB)]

    hp = @hp C := Segment(A, B) ⟂ Segment(C, D)
    @test hp.points == Dict(:A => free, :B => free, :C => sf, :D => free)
    @test hp.constraints == [Perpendicularity(AB, CD)]


    hp = @hp C := Segment(A, B) ∥ Segment(C, D)
    @test hp.points == Dict(:A => free, :B => free, :C => sf, :D => free)
    @test hp.constraints == [Parallelism(AB, CD)]


    hp = @hp C := Segment(A, B) ≅ Segment(C, D)
    @test hp.points == Dict(:A => free, :B => free, :C => sf, :D => free)
    @test hp.constraints == [Congruence(AB, CD)]

    hp = @hp P := Segment(A, B) ∩ Segment(C, D)
    @test hp.points == Dict(:A => free, :B => free, :C => free, :P => dep, :D => free)
    @test hp.constraints == [Intersection(:P, AB, CD)]

    hp = @hp H := A ↓ Segment(C, D)
    @test hp.points == Dict(:A => free, :D => free, :C => free, :H => dep)
    @test hp.constraints == [Projection(:H, :A, CD)]

    hp1 = @hp M := Midpoint(A, B)
    hp2 = @hp M := Midpoint(Segment(A, B))
    hp3 = @hp M := midpoint(A, B)
    hp4 = @hp M := Midpoint(Segment(A, B))
    for hp in (hp1, hp2, hp3, hp4)
        @test hp.points == Dict(:A => free, :B => free, :M => dep)
        @test hp.constraints == [Midpoint(:M, AB)]
    end

    hp1 = @hp D := Parallelogram(A, B, C, D)
    hp2 = @hp C := parallelogram(A, B, C, D)

    @test hp1.points == Dict(:A => free, :B => free, :C => free, :D => dep)
    @test hp2.points == Dict(:A => free, :B => free, :C => dep, :D => free)
    @test hp1.constraints == [Parallelogram(:A, :B, :C, :D)]
    @test hp2.constraints == [Parallelogram(:A, :B, :C, :D)]

    # THESIS
    th = @th Segment(A, B) ∥ Segment(C, D)
    @test th.constraints == [Parallelism(AB, CD)]

    th = @th P ∈ Segment(C, D)
    @test th.constraints == [Appartenence(:P, CD)]
end

@testset "parse multiple statements" begin
    free = GTP.Free()
    dep12 = GTP.Dependent(1, 2)
    dep3 = GTP.Dependent(3)
    hp = @hp begin
        points(A, B, C)
        B := Segment(A, B) ⟂ Segment(B, C)
        B := Segment(A, B) ≅ Segment(B, C)
        M := Midpoint(A, B)
    end

    AB = Segment(:A, :B)
    BC = Segment(:B, :C)

    @test hp.points == Dict(:A => free, :B => dep12, :C => free, :M => dep3)
    @test hp.constraints == [Perpendicularity(AB, BC), Congruence(AB, BC), Midpoint(:M, AB)]

    th = @th begin
        Segment(A, B) ⟂ Segment(B, C)
        Segment(A, B) ≅ Segment(B, C)
    end
    @test th.constraints == [Perpendicularity(AB, BC), Congruence(AB, BC)]
end

@testset "point status algebra" begin
    free = GTP.Free()
    sf1 = GTP.SemiFree(1)
    sf2 = GTP.SemiFree(2)
    dep = GTP.Dependent(3)

    for s in (free, sf1, dep)
        @test GTP._update_status(free, s) == s
        @test GTP._update_status(s, free) == s
    end

    @test GTP._update_status(sf1, sf2) == GTP.Dependent(1, 2)

    @test_throws ArgumentError GTP._update_status(sf1, dep)
    @test_throws ArgumentError GTP._update_status(dep, sf1)
    @test_throws ArgumentError GTP._update_status(dep, dep)
end
