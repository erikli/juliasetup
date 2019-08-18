# modified from https://gist.github.com/terasakisatoshi/14f8fa8bab35683061306f96b1fcf96f
using PackageCompiler
using Pkg

println( "### PackageCompiler and any packages for which you want to build a system image need to be added into the system root. They cannot be in an environment only." )

if in("GR",keys(Pkg.installed()))
    @eval import GR
else
    Pkg.add("GR")
    @eval import GR
end

if Sys.iswindows()
    s=joinpath(dirname(dirname(pathof(GR))),"deps","gr","bin")
    s*=';'
    if !endswith(ENV["PATH"],';')
        ENV["PATH"] *= ';'
    end
    ENV["PATH"] *= s
else
    s=joinpath(dirname(dirname(pathof(GR))),"deps","gr","lib")
    s*=':'
    if haskey(ENV, "LD_LIBRARY_PATH")
        ENV["LD_LIBRARY_PATH"] *= s
        if !endswith(ENV["LD_LIBRARY_PATH"],':')
            ENV["LD_LIBRARY_PATH"] *= ':'
        end
    else
        ENV["LD_LIBRARY_PATH"] = s
    end
end

let
  files = compile_incremental(pwd()*"\\Project.toml",pwd()*"\\userimg.jl",force=false)
  println(files)
  println("Copy "*files[1]*" somewhere where it will be easy to call `julia -J /path/to/sys.dll`.")
end
