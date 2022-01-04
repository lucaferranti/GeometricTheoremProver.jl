using GeometricTheoremProver
using OrderedCollections
using DynamicPolynomials
using Test
const GTP = GeometricTheoremProver

using GeometricTheoremProver: Segment, Parallelism, Perpendicularity, Congruence, Appartenence, Intersection, Midpoint, Parallelogram, Projection

include("test_parser.jl")
include("test_rittwu.jl")
