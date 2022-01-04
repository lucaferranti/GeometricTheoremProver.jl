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
  creates a point P constraints to lie on the line perpendicular to AB and passing through A, hence it only has one DoF, i.e. it is semifree. Adding the constraint
  ```
  P := Segment(A, B) ≅ Segment(A, P)
  ```
  further constraints the point to have distance from A equal to AB, now the point is uniquely defined by two constraints and hence it is dependent.

- The semifree + semifree = dependent does not check for possibly contradicting statements, for example if you type
  ```
  A := Segment(A, B) ⟂ Segment(C, D)
  A := Segment(A, B) ∥  Segment(C, D)
  ```
  it cannot notice that the two statements are contradicting.
