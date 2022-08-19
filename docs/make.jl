using GeometricTheoremProver
using Documenter

DocMeta.setdocmeta!(GeometricTheoremProver, :DocTestSetup, :(using GeometricTheoremProver); recursive=true)

makedocs(;
    modules=[GeometricTheoremProver],
    authors="Luca Ferranti",
    repo="https://github.com/lucaferranti/GeometricTheoremProver.jl/blob/{commit}{path}#{line}",
    sitename="GeometricTheoremProver.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://lucaferranti.github.io/GeometricTheoremProver.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Tutorial" => "write_statements.md",
        "API docs" => [
            "API" => "api.md",
            "Language specification" => "language.md"
        ],
        "Contributing" => "CONTRIBUTING.md"
    ],
)

deploydocs(;
    repo="github.com/lucaferranti/GeometricTheoremProver.jl",
    devbranch="main",
    push_preview=true
)
