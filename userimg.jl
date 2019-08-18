using Plots
using DifferentialEquations

# cache things for the first plot
gr()
plot(1:4,1:4)

# cache things for ODE solvers
let
  function f(du,u,p,t)
    du .= 0
  end

  # u0 is 2-D array
  u0 = [0.0 0.0 0.0]# Array{Float64,2}
  solve( ODEProblem(f,u0,(0.0,1.0)) )
  solve( ODEProblem(f,u0,(0.0,1.0)),Rodas4() )
  solve( ODEProblem(f,u0,(0.0,1.0)),QNDF() )
  solve( ODEProblem(f,u0,(0.0,1.0)),AutoVern9(Rodas4P()) )
  solve( ODEProblem(f,u0,(0.0,1.0)),AutoVern7(Rodas5()) )

  # u0 is 1-D array
  u0 = vec([0.0 0.0 0.0])# Array{Float64,1} / 1-D array
  solve( ODEProblem(f,u0,(0.0,1.0)) )
  solve( ODEProblem(f,u0,(0.0,1.0)),Rodas4() )
  solve( ODEProblem(f,u0,(0.0,1.0)),QNDF() )
  solve( ODEProblem(f,u0,(0.0,1.0)),AutoVern9(Rodas4P()) )
  solve( ODEProblem(f,u0,(0.0,1.0)),AutoVern7(Rodas5()) )

  # add parameters
  p = [1.0 2.0]
  u0 = [0.0 0.0 0.0]
  solve( ODEProblem(f,u0,(0.0,1.0),p) )
  solve( ODEProblem(f,u0,(0.0,1.0),p),Rodas4() )
  solve( ODEProblem(f,u0,(0.0,1.0),p),QNDF() )
  solve( ODEProblem(f,u0,(0.0,1.0),p),AutoVern9(Rodas4P()) )
  solve( ODEProblem(f,u0,(0.0,1.0),p),AutoVern7(Rodas5()) )
  u0 = vec([0.0 0.0 0.0])
  solve( ODEProblem(f,u0,(0.0,1.0),p) )
  solve( ODEProblem(f,u0,(0.0,1.0),p),Rodas4() )
  solve( ODEProblem(f,u0,(0.0,1.0),p),QNDF() )
  solve( ODEProblem(f,u0,(0.0,1.0),p),AutoVern9(Rodas4P()) )
  solve( ODEProblem(f,u0,(0.0,1.0),p),AutoVern7(Rodas5()) )
  p = vec([1.0 2.0])
  u0 = [0.0 0.0 0.0]
  solve( ODEProblem(f,u0,(0.0,1.0),p) )
  solve( ODEProblem(f,u0,(0.0,1.0),p),Rodas4() )
  solve( ODEProblem(f,u0,(0.0,1.0),p),QNDF() )
  solve( ODEProblem(f,u0,(0.0,1.0),p),AutoVern9(Rodas4P()) )
  solve( ODEProblem(f,u0,(0.0,1.0),p),AutoVern7(Rodas5()) )
  u0 = vec([0.0 0.0 0.0])
  solve( ODEProblem(f,u0,(0.0,1.0),p) )
  solve( ODEProblem(f,u0,(0.0,1.0),p),Rodas4() )
  solve( ODEProblem(f,u0,(0.0,1.0),p),QNDF() )
  solve( ODEProblem(f,u0,(0.0,1.0),p),AutoVern9(Rodas4P()) )
  solve( ODEProblem(f,u0,(0.0,1.0),p),AutoVern7(Rodas5()) )
end
