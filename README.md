# Julia language for scientific computing

## Why Julia?
Julia is an option for scientific computing that requires high throughput. Julia is a JIT compiled language which offers the benefits of an interpreted language (interactive REPL, Jupyter notebooks) with the speed of a compiled language which leverages LLVM (bytecode compiled with the same VM used by Clang for C/C++). This does mean that compile time becomes a factor, which can effect startup time the first time you use a function. See below for instructions on setting up Julia to precompile the system image in order to remove the startup penalty on things you use often.

This also means that global variables produce a comparatively significant performance hit on Julia because Julia compiles multiple versions of each function (methods), each of which corresponds to a different type signature both for arguments and any variables used. Since global variables may change type at any time, this means that the Just-in-Time (JIT) must compile a new version of the function if the global changes type. You can get around this by declaring global variables `const` (which interestingly only `const`s their type although other weird things can happen if you do change the value anyways) or by using closures (essentially variable currying) so that the type is known beforehand.

For a much more thorough take from UC Irvince Data Science Initiative with a deeper technical discussion of the design decisions that made Julia attractive, see https://ucidatascienceinitiative.github.io/IntroToJulia/Html/WhyJulia.

## Install
1. Follow instructions to install Anaconda Python since a few Julia packages rely on python functionality
2. Install Julia from julialang.org
3. **Highly Recommended** Precompile System Image using instructions below

## Add Julia to PATH
- Note that this isn't strictly necessary and possibly even advised against on Windows
- For Windows 10, a possibly better option than actually adding Julia to path is to alias `julia` to `C:\Users\<USERNAME>\AppData\Local\<JULIAFOLDER>\bin\julia.exe` (see https://stackoverflow.com/questions/20530996/aliases-in-windows-command-prompt for details on using DOSKEY to create aliases and also how to make them persistent using `.bat` files run via the `AutoRun` registry key)
- For Windows 10, "Edit Environment Variables" either by
    - Start menu search "environment variables"
    - right-click "This PC" and go to Properties->Advanced tab->Environment Variables
    - To `PATH` variable, add "C:\Users\<USERNAME>\AppData\Local\<JULIAFOLDER>"
        - You do not want to add the "bin" folder directly because otherwise other programs with incompatible shared libraries (DLLs) may pick up the wrong dependencies (see https://github.com/JuliaLang/julia/pull/29141#issuecomment-422481356 for discussion)
    - Either modify `PATHEXT` to include `.lnk` so that the Julia shortcut will run, or make a symbolic link to `bin\julia.exe` using `mklink` (See https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/cc753194(v=ws.11))
- For Windows Subsystem for Linux (WSL) add julia.exe to your path
    - i.e. in `~/.bashrc` add `PATH=/mnt/c/Users/<USERNAME>/AppData/Local/<JULIAFOLDER>/bin`

## Precompile System Image with useful things for ODE solvers and plotting
1. Download `buildimg.jl`, `userimg.jl` and `setupjl.jl` into a folder
2. `shell> julia setupjl.jl` will setup the folder as an environment and install `Plots`, `GR` (a Plots backend), `DifferentialEquations` and the development version of `PackageCompiler`. See below for more details if you are interested.
    - This could take a few minutes.
3. `shell> julia buildimg.jl` to build a new system image.
    - This will take even longer
    - Copy the results sys.dll somewhere convenient so you can run `julia -J /path/to/sys.dll` and get your new shiny, fast system image.
4. If there is something you want to add to the system image, just modify `userimg.jl` to include statements of the `using package` variety and also run any of the functions that take a long time normally after `using package`. So for example the default `userimg.jl` has `using Plots; gr(); plot(1:5,1:5)` so that the full `plot` routines get cached. It would also be good to update the `Project.toml` file that is generated by `setupjl.jl`. This can be done directly or by modifying `setupjl.jl` and re-running it.
5. **You will also have to rebuild the system image if you update any of the packages which are in the image - i.e. `Plots` or `DifferentialEquations`**

## Install Packages (using environments)
- See https://julialang.github.io/Pkg.jl/v1/ and https://docs.julialang.org/en/v1/stdlib/Pkg/index.html for more information on package management in Julia
- I suggest using project-specific environments
    - create a folder that will contain the project `projfolder`
    - start Julia from `projfolder` or else start Julia and `cd("<projfolder>")` i.e. `cd("C:\Users\<USERNAME>\Documents\jl_project")`
- From Julia command prompt, type `]` to start package manager
    - `activate .` to activate the environment (could also `activate <projfolder>` with the correct path)
    - `add <pkgspec>` to install package
    - `precompile` to precompile the packages for better load times **Highly Recommended**
    - `rm <pkgspec>` to remove package and then `gc` to remove dependencies
    - `<Backspace>` to exit `pkg` prompt

## Recommended Packages (mostly installed if you followed the setup instructions and used `setupjl.jl`)
- Plotting (https://julialang.org/downloads/plotting.html)
    - `Plots` for general plotting
    - `Gadfly` for `R` style plotting using grammar of graphics like `ggplot2`
- `DifferentialEquations` (http://docs.juliadiffeq.org/latest/)
    - The whole reason I'm using Julia is for the performance of this package
    - See http://juliadiffeq.org/citing.html for citing the software
    - Also see
        - http://www.stochasticlifestyle.com/comparison-differential-equation-solver-suites-matlab-r-julia-python-c-fortran/
        - http://www.stochasticlifestyle.com/solving-systems-stochastic-pdes-using-gpus-julia/ for information on using globals (**must use `const` for efficiency**), closures or overloaded types
- `ProgressLogging`
    - Progress bars in the style of `ProgressMeter.jl` but which use the Julia 1.0+ logging mechanism
    - Not in the Julia package registry so needs to be added by `pkg> add https://github.com/adamslc/ProgressLogging.jl` (this is done if you run the `setupjl.jl` script)
- `PackageCompiler.jl` (https://github.com/JuliaLang/PackageCompiler.jl)
    1. **NOTE: PackageCompiler and other packages you wish to precompile into a system image must be installed into the system root and not just into an environment**
    2. put the `buildimg.jl` and `userimg.jl` files in the same directory
    3. `shell> cd /path/to/buildimg/and/userimg/folder`
    4. `shell> julia -L buildimg.jl` with the `buildimg.jl` and `userimg.jl` files included in this repo in the same directory.
    5. `shell> julia -J <path/to/system/image>` - startup command for julia with nice system image
    6. Also see:
        - http://gadflyjl.org/stable/ for other instructions on how to use this package
        - https://discourse.julialang.org/t/tips-for-using-packagecompiler-jl-on-windows/22295/3 for instructions on using compile_incremental()
        - https://gist.github.com/terasakisatoshi/14f8fa8bab35683061306f96b1fcf96f **gist for building Plots that was necessary for these instructions**
        - https://medium.com/@sdanisch/compiling-julia-binaries-ddd6d4e0caf4
        - https://docs.julialang.org/en/v1/devdocs/sysimg/#Building-the-Julia-system-image-1 (Apparently this is outdated and soon to be deprecated in favor of PackageCompiler)
        - https://docs.julialang.org/en/v1/manual/modules/index.html
- `Parameters.jl` https://github.com/mauro3/Parameters.jl and docs at https://mauro3.github.io/Parameters.jl/stable
    - provides significant speedup over straight closures (setting local variables in a function, then returning a nested function referencing those variables) for some reason
    - See https://discourse.julialang.org/t/model-configuration-parameterization-file/8982/8
        

### Possible packages of interest
- `ODEInterfaceDiffEq`
    - provides `radau()` ODE solver method for high-accuracy (low-tolerance) ODE solving
    - require gfortran
- `CuArrays` -- for GPU acceleration in `DifferentialEquations`
    - Just make the initial conditions a CuArray - `x0 = CuArray(x0)`
    - Need to first install CUDA toolkit (for NVIDIA cards only) from https://developer.nvidia.com/cuda-toolkit
- `ProgressMeter` for nice progress meters on the REPL, also maybe look at the Juno editor progressbars
- `CSV` for reading and writing `.csv` files
    - Also depends on `DataFrames` and other friends that may be useful especially if you are from an `R` background
