using Documenter, Lingeling

makedocs(
    sitename="Lingeling.jl",
    authors="Soeren Viegener",
    modules = [Lingeling],
    pages=[
        "Home" => "index.md",
        "Installation" => "installation.md",
        "Example" => "example.md",
        "API Reference" => "api.md",
    ]
)