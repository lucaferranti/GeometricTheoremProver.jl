module GeometricTheoremProver

import Base: show

using DynamicPolynomials
using OrderedCollections

export @hp, @th, Theorem, prove, Coordinate, RittWuMethod, isproved, ndg

include("geometry/primitives.jl")
include("geometry/constraints.jl")
include("geometry/point_status.jl")

include("theorem/theorem.jl")
include("theorem/parse_constraints.jl")
include("theorem/parse_theorem.jl")

include("rittwu/coordinates.jl")
include("rittwu/algebry.jl")
include("rittwu/triangulize.jl")
include("rittwu/prove.jl")
end
