using Pkg

pkg"add Plots"
pkg"add GR"
pkg"add DifferentialEquations"
pkg"dev PackageCompiler"

# Also generate the `Project.toml` file
pkg"activate ."
pkg"add Plots"
pkg"add DifferentialEquations"
pkg"add Parameters"
pkg"add https://github.com/adamslc/ProgressLogging.jl"
