# License for this file: MIT (expat)
# Copyright 2017-2018, DLR Institute of System Dynamics and Control


"""
    ModiaMath - Mathematical Utilities for Modia and Modia3D

To define a model use Modia or Modia3D. You can define a model
natively in ModiaMath in the following way:

```julia
  using ModiaMath
  using StaticArrays

  @component Pendulum(;L=1.0, m=1.0, d=0.1, g=9.81) begin
     phi = RealScalar(start=pi/2, unit="rad"    , fixed=true,               numericType=ModiaMath.XD_EXP)
     w   = RealScalar(start=0.0 , unit="rad/s"  , fixed=true, integral=phi, numericType=ModiaMath.XD_EXP)
     a   = RealScalar(            unit="rad/s^2",             integral=w  , numericType=ModiaMath.DER_XD_EXP)
     r   = RealSVector{2}(        unit="m"      ,                           numericType=ModiaMath.WC)
  end;

  function ModiaMath.computeVariables!(p::Pendulum, sim::ModiaMath.SimulationState)
     L = p.L; m = p.m; d = p.d; g = p.g; phi = p.phi.value; w = p.w.value

     p.a.value = (-m*g*L*sin(phi) - d*w) / (m*L^2)

     if ModiaMath.isStoreResult(sim)
        p.r.value = @SVector [L*sin(phi), -L*cos(phi)]
     end
  end;

  simulationModel = ModiaMath.SimulationModel(Pendulum(L=0.8, m=0.5, d=0.2), stopTime=5.0);
```

To simulate a model and plot results:

```julia
  result = ModiaMath.simulate!(simulationModel; log=true);
  ModiaMath.plot(result, [(:phi, :w) :a])
```

[PendulumPlot](PendulumPlot-url)


To run examples:
```julia
  include("$(ModiaMath.path)/examples/Simulate_Pendulum.jl")
  include("$(ModiaMath.path)/examples/Simulate_FreeBodyRotation.jl")
  include("$(ModiaMath.path)/examples/withoutMacros_withoutVariables/Simulate_SimpleStateEvents.jl")
  include("$(ModiaMath.path)/examples/withoutMacros_withoutVariables/Simulate_BouncingBall.jl")
```

To run tests:
```julia
  include("$(ModiaMath.path)/test/runtests.jl")
```

For more information, see (https://github.com/ModiaSim/ModiaMath.jl/blob/master/README.md)
"""
module ModiaMath

"""
    const path

Absolute path of package directory of ModiaMath
"""
const path = dirname(dirname(@__FILE__))   # Absolute path of package directory
const Time = Float64   # Prepare for later Integer type of time
const Version = "0.5.1"
const Date = "2019-04-07"

println(" \nImporting ModiaMath Version $Version ($Date)")



# Exported symbols
export @component
export RealVariable, RealScalar, RealSVector, RealSVector3
export plot


# Import packages that are used in examples and tests
# (in order that there are no requirements on the environment
#  in which the examples and tests are executed).
using StaticArrays

getVariableAndResidueValues(extraInfo::Any) = nothing    # Return a variable value and a residue value table of nonlinear solver (for error message)


# include sub-modules and make symbols available that have been exported in sub-modules
include("TypesAndStructs.jl")
using .TypesAndStructs

include("Utilities.jl")
using .Utilities

include("Logging.jl")
using .Logging

include(joinpath("Frames", "_module.jl"))
using .Frames

#include("SparseJacobian.jl")
#using .SparseJacobian

include(joinpath("Result", "_module.jl"))
using .Result

include(joinpath("NonlinearEquations", "_module.jl"))
using .NonlinearEquations
const NonlinearEquationsInfo   = NonlinearEquations.KINSOL.NonlinearEquationsInfo
const solveNonlinearEquations! = NonlinearEquations.KINSOL.solveNonlinearEquations!

include(joinpath("DAE", "_module.jl"))
using .DAE

include(joinpath("SimulationEngine", "_module.jl"))
using .SimulationEngine

include(joinpath("Variables"       , "_module.jl"))
using .Variables

include("ModiaToModiaMath.jl")
using .ModiaToModiaMath


end # module
