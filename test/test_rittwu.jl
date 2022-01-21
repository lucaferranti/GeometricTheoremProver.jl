@testset "ritt-wu method" begin
    # Apollonius circle theorem
    hp = @hp begin
        points(A, B, C)
        C := Segment(A, B) ⟂ Segment(A, C)
        M₁ := Midpoint(A, B)
        M₂ := Midpoint(A, C)
        M₃ := Midpoint(B, C)
        H := A ↓ Segment(B, C)
        O := Circle(M₁, M₂, M₃)
    end

    th = @th H ∈ circle(O, M₁)
    p = prove(hp, th)
    @test p.coords[:A] == GTP.Coordinate(0, 0)
    @test p.coords[:A].y == 0
    @test all(isproved(p))

    # test with user given coordinates, example 3 of sec. 6.5 of [CLO15]
    @polyvar u[1:2] x[1:8]

    coords = OrderedDict(
       :A => Coordinate(0, 0),
       :B => Coordinate(u[1], 0),
       :C => Coordinate(0, u[2]),
       :M₁ => Coordinate(x[1], 0),
       :M₂ => Coordinate(0, x[2]),
       :M₃ => Coordinate(x[3], x[4]),
       :H => Coordinate(x[5], x[6]),
       :O => Coordinate(x[7], x[8])
    )
    p = prove(hp, th, RittWuMethod, coords, u, x)
    H_ = [
        2x[1] - u[1],
        2x[2] - u[2],
        2x[3] - u[1],
        2x[4] - u[2],
        -u[2]*x[5] - u[1]*x[6] + u[1]*u[2],
        -u[1]*x[5] + u[2]*x[6],
        x[1]^2 - x[2]^2 - 2*x[1]*x[7] + 2*x[2]*x[8],
        x[1]^2 - 2x[1]*x[7] - x[3]^2 + 2*x[3]*x[7] - x[4]^2 + 2x[4]*x[8],
    ]

    T_ = [
        2x[1] - u[1],
        2x[2] - u[2],
        2x[3] - u[1],
        2x[4] - u[2],
        -(u[1]^2 + u[2]^2) * x[5] + u[1]*u[2]^2,
        -u[1]*x[5] + u[2]*x[6],
        2*(x[1]*x[2] - x[2]*x[3] - x[1]*x[4])*x[7] - x[1]^2*x[2] + x[2]*x[3]^2 + x[1]^2*x[4] - x[2]^2*x[4] + x[2]*x[4]^2,
        x[1]^2 - 2x[1]*x[7] - x[3]^2 + 2*x[3]*x[7] - x[4]^2 + 2x[4]*x[8],
    ]

    @test p.H == H_
    T = map(x -> x ÷ gcd(x.a), p.T)
    @test T == T_

    @test ndg(p) == [-u[1]^2 - u[2]^2, u[2], 4*x[1]*x[2]-4*x[1]*x[4] - 4*x[2]*x[3], 2*x[4]]

    # Properties of parallelogram
    hp = @hp begin
        D := Parallelogram(A, B, C, D)
        O := Segment(A, C) ∩ Segment(B, D)
    end

    th = @th begin
        Segment(A, O) ≅ Segment(O, C)
        Segment(A, B) ∥ Segment(A, C) # this is obviously false
    end

    p = prove(hp, th)
    @test isproved(p) == [true, false]

    thm = Theorem(hp, th)
    @test thm isa Theorem{GTP.NoProof}
    @test !isproved(thm)

    thm = prove(thm)
    @test isproved(thm) == [true, false]

    @test string(thm) == "POINTS:\n------------\nA : free\nB : free\nC : free\nD : dependent by (1)\nO : dependent by (2)\n\nHYPOTHESIS:\n------------\n(1) ABCD parallelogram\n(2) O = AC ∩ BD\n\nTHESIS:\n------------\nAO ≅ OC\nAB ∥ AC\n\nAssigned coordinates:\n---------------------\nA = (0, 0)\nB = (u₁, 0)\nC = (u₂, u₃)\nD = (x₁, x₂)\nO = (x₃, x₄)\n\nGoal 1: success\nGoal 2: fail\n\nNondegeneracy conditions:\n-------------------------\nu₁u₃ + u₂x₂ - u₃x₁ ≠ 0\n-u₁ + x₁ ≠ 0\n"
end
