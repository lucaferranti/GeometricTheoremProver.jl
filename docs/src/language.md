# Language specifications

This document lists the statements allowed in the GeometricTheoremProver DSL, describing whether they introduce new points and if they are free, semifree, or dependent


| **Statement**                      | **New points**                    | **Constraints**                             |
|:----------------------------------:|:---------------------------------:|:-------------------------------------------:|
|points(PP...)                       | points in PP free                 | none                                        |
|P := P ∈ Segment(A, B)              | A B free, P semifree              | P ∈ AB                                      |
|D := Segment(A, B) ⟂ Segment(C, D)  | A B C free, D semifree            | AB ⟂ CD                                     |
|D := Segment(A, B) ∥ Segment(C, D)  | A B C free, D semifree            | AB ∥ CD                                     |
|D := Segment(A, B) ≅ Segment(C, D)  | A B C free, D semifree            | AB ≅ CD                                     |
|D := Parallelogram(A, B, C, D)      | A B C free, D dependent           | parallelogram(A, B, C, D)                   |
|H := A ↓ Segment(B, C)              | A B C free, H dependent           | H ∈ BC, AH ⟂ BC                             |
|M := Midpoint(A, B)                 | A B free, M dependent             | M = midpoint(A, B)                          |
|M := Segment(A, B) ∩ Segment(C, D)  | A B C D free, M dependent         | M ∈ AB, M ∈ CD                              |
|O := Circle(A, B, C)                | A B C free, O dependent           | OA ≅ OB ≅ OC                                |
|P := P ∈ Circle(O, A)               | O A free, P semifree              | OA ≅ OP                                     |

If the point already exists and the statement tries to add the point again, the behavior is detemined by the next table

|**Current status**|**New status**   |**Outcome**|
|:----------------:|:---------------:|:---------:|
| free             | s               | s         |
| semifree         | free            | semifree  |
| semifree         | semifree        | dependent |
| semifree         | dependent       | error     |
| dependent        | free            | dependent |
| dependent        | semifree        | error     |
| dependent        | dependent       | error     |

NOTES:

- The idea behind the semifree + semifree = dependent rule is to allow to define points by multiple constraints. For example,
  ```
  P := Segment(A, B) ⟂ Segment(A, P)
  ```
  creates a point P constrained to lie on the line perpendicular to AB and passing through A. There are infinitely many candidates, but not all points in the plane are good candidates, hence the point is semifree. Adding the constraint
  ```
  P := Segment(A, B) ≅ Segment(A, P)
  ```
  further constraints the point to have distance from A equal to AB. As there are not infinitely many candidates, the point is dependent.

- The semifree + semifree = dependent does not check for possibly contradicting statements, for example if you type
  ```
  A := Segment(A, B) ⟂ Segment(C, D)
  A := Segment(A, B) ∥  Segment(C, D)
  ```
  it cannot notice that the two statements are contradicting.
