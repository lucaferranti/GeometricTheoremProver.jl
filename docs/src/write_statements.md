# First Theorem

This is a beginner tutorial to GeometricTheoremProver.jl. To follow along, you need to install the package with

```julia
using Pkg; Pkg.add("GeometricTheoremProver")
```

Then you can import the package with

```@example tutorial
using GeometricTheoremProver
```

## Introduction

Generally speaking, a theorem is composed by two parts: a *hypothesis*, that is a set of statements assumed to hold and a *thesis*, that is a set of statements to be derived from the hypothesis and the axioms of the theory we are working in.

Theorems in Euclidean geometry involve geometric entities such as points, lines, circles etc. The hypothesis of the theorem can also be thought as a set of *constraints* on the points. This can be seen as a set of constructions steps to draw the figure of the theorem. For example the constraint `P ∈ Segment(A, B)` can be read as *take a point P on the Segment AB*, this sets some restrictions on what points in the plane we can choose for $$P$$.

A point can be

- **free**: any point in the plane satisfies the statement.
- **semifree**: there are infinitely many points satisfying the given statement, but not all points in the plane do. Thinking of the Cartesian plane as model for Euclidean geometry, this means that one coordinate can be freely chosen, but the other is then uniquely determined.
- **dependent**: There is a finite number of points satisfying the given statement.

With this interpretation, we say that points are introduced by a series of construction steps. These steps form the hypothesis of the theorem

## Writing hypothesis

The hypothesis is written using the [`@hp`](@ref) macro. The macro can be followed by a single expression of by a `begin ... end` block
containing multiple expressions.

Free points can be introduced with the `points` function. For example,

```@example tutorial
@hp points(A, B, C)
```

As we can see, this introduces the free points `A, B, C`. Since all points are free, there are no constraints in this case.

The general syntax to write constraint is

```
P := constraint
```

this can be read as *Let P so that constraint*. As you can see, you need to explicitly specify what point is introduced by the constraint. For example

```@example tutorial
@hp P := P ∈ Segment(A, B)
```

Now the hypothesis shows that `P` is semifree and constrained by statement number (1). Note also that points `A` and `B` are automatically introduced as free, even without calling `points(A, B)`. In general given a statement `P := constraint`, the package will add `P` as dependent or semifree (depending on the constraint) and all the other points will be added as free if they don't exist already. Let us see a bigger example

```@example tutorial
@hp begin
    M := Midpoint(A, B)
    P := Segment(P, M) ⟂ Segment(A, B)
    P := Segment(P, M) ≅ Segment(A, M)
end
```

This is basically taking a point `P` on the perpendicular bisector of `AB`. Let us now notice a few things

- The midpoint of a segment is uniquely defined, hence the statement `M := Midpoint(A, B)` introduces `M` as dependent.
- The second statement `P := Segment(P, M) ⟂ Segment(A, B)` takes a point `P` on the perpendicular bisector of `AB`. Since the point is not uniquely defined by this statement alone, `P` would be semifree
- The next statement, however, `P := Segment(P, M) ≅ Segment(A, M)` adds an additional constraint on `P`, after which `P` is uniquely defined and hence it is displayed as dependent, constrained by equations (1) and (2).

If you specify a point as semifree by two distinct constraints, the package "sums" the two constraints and marks the point as dependent.

The package also prevents you from adding too many constraints to a point, for example the follow would result in an error.

```julia
@hp begin
  points(A, B, C)
  M := Midpont(A, B)
  M := Segment(A, B) ⟂ Segment(C, M)
end
```

```
ERROR: LoadError: ArgumentError: Cannot add statement (2) to point already defined as dependent by (1)
```

The constraints `M := Midpoint(A, B)` already defined uniquely the point `M`, any extra constraint will be either redundant or contradictory.

A list of all allowed constraints and a full description of the "point status algebra" can be found [here](language.md).

## Writing Thesis

A thesis is created with the [`@th`](@ref) macro, followed by a single expression or a `begin ... end` block. The same constraint syntax used in the hypothesis applies for the thesis, except that now we don't have the `P :=` part, as the thesis does not introduce new points. A couple of examples

```@example tutorial
@th Segment(A, B) ⟂ Segment(C, D)
```

```@example tutorial
@th begin
    Segment(A, O) ≅ Segment(O, C)
    Segment(B, O) ≅ Segment(O, D)
end
```

## Proving the theorem

After you have written the hypothesis and thesis, you can prove the theorem with the [`prove`](@ref) function. At the moment, only simple Ritt-Wu method is supported. As an example, let us see the Apollonius circle theorem. We choose this theorem because it is a nice show-case, as it uses most of the expressions allowed in the package

```@example tutorial
hp = @hp begin
        points(A, B, C)
        C  := Segment(A, B) ⟂ Segment(A, C)
        M₁ := Midpoint(A, B)
        M₂ := Midpoint(A, C)
        M₃ := Midpoint(B, C)
        H  := A ↓ Segment(B, C) # H is the projection of A to the segment BC
        O  := Circle(M₁, M₂, M₃)
    end
```

```@example tutorial
th = @th H ∈ circle(O, M₁)
```

```@example tutorial
p = prove(hp, th)
```

Ritt-Wu method is an algebraic method, which means that it first assigns some coordinates to the points and then translates
the statements to polynomial equations. Free coordinates are denoted by the letter `u` and dependent coordinates by `x`.

Proving the theorem now "simply" means doing some operations on the polynomials. Since the proof is a bunch of calculations,
it is generally not that interesting to read, hence by default it is only displayed whether the thesis could be successfully proved or not.

The proof also shows the *non-degeneracy conditions*. When we construct a triangle with vertices, $$A, B, C$$ we are generally interested in "proper triangles", that is the three vertices are distinct and not on the same line. Otherwise we say we have a *degenerate case*, in which case the theorem may not hold. However, we are generally interested only in the non-degenerate case and hence the algorithm also computes some extra hypotheses called *degeneracy conditions* needed for the theorem to hold. If a theorem holds under some non-degeneracy conditions, we say that the thesis *follows generally* from the hypothesis. If the thesis always follows from the hypothesis, even in possible degenerate cases, we say that the thesis *follows strictly* from the hypothesis.

As an illustrative example, let us look closer at the obtained conditis

1. $$u_1 \neq 0$$ Recalling that $$A$$ is at the origin and $$B$$ had coordinates $$(u_1, 0)$$, the condition is equivalent to $$A \nequiv B$$.
2. $$-u_1^2+2u_1x_1-u_2^2-x_1^2\neq 0$$ With a small rewriting the corresponding degeneracy condition is $$(u_1-x_1)^2+u_2^2=0$$, since we are working with real variables this is equivalent to $$u_1 = x_1 \land u_2=0$$ whence the coordinates of $$C$$ become $$(u_1, 0)$$, which are the same of $$B$$. Hence the non-degeneracy condition is equivalent to $$B \not\equiv  C$$.

In general, figuring out the geometrical interpretation of the algebraic non-degeneracy conditions can be pretty challenging.