@testset "ritt-wu method" begin
    @polyvar u[1:2] x[1:8]

    H = [
        2x[1] - u[1],
        2x[2] - u[2],
        2x[3] - u[1],
        2x[4] - u[2],
        u[2]*x[5] + u[1]*x[6] - u[1]*u[2],
        u[1]*x[5] - u[2]*x[6],
        x[1]^2 - x[2]^2 - 2*x[1]*x[7] + 2*x[2]*x[8],
        x[1]^2 - 2x[1]*x[7] - x[3]^2 + 2*x[3]*x[7] - x[4]^2 + 2x[4]*x[8],
    ]

    T_ = [
        2x[1] - u[1],
        2x[2] - u[2],
        2x[3] - u[1],
        2x[4] - u[2],
        -(u[1]^2 + u[2]^2) * x[5] + u[1]*u[2]^2,
        u[1]*x[5] - u[2]*x[6],
        2*(x[1]*x[2] - x[2]*x[3] - x[1]*x[4])*x[7] - x[1]^2*x[2] + x[2]*x[3]^2 + x[1]^2*x[4] - x[2]^2*x[4] + x[2]*x[4]^2,
        x[1]^2 - 2x[1]*x[7] - x[3]^2 + 2*x[3]*x[7] - x[4]^2 + 2x[4]*x[8],
    ]
    T = map(x -> x ÷ gcd(x.a), GTP.triangulize(H, x))
    @test T == T_

    # Apollonius circle theorem
    hp = @hp begin
        points(A, B, C)
        C := Segment(A, B) ⟂ Segment(A, C)
        M₁ := Midpoint(A, B)
        M₂ := Midpoint(B, C)
        M₃ := Midpoint(A, C)
        O := Circle(M₁, M₂, M₃)
        H := A ↓ Segment(B, C)
    end
    th = @th H ∈ circle(O, M₁)
    p = prove(hp, th)
    @test p.coords[:A] == GTP.Coordinate(0, 0)
    @test p.coords[:A].y == 0
    @test all(isproved(p))

    # Properties of parallelogram
    hp1 = @hp begin
        D := Parallelogram(A, B, C, D)
        O := Segment(A, C) ∩ Segment(B, D)
    end

    th1 = @th begin
        Segment(A, O) ≅ Segment(O, C)
        Segment(A, B) ∥ Segment(A, C) # this is obviously false
    end

    p = prove(hp1, th1)
    @test isproved(p) == [true, false]
end
