# License for this file: MIT (expat)
# Copyright 2017-2018, DLR Institute of System Dynamics and Control

"""
    module Simulate_StateSelection

DAE-model to test manual state selection of simple multibody system.
"""
module Simulate_StateSelection

import ..ModiaMath
using  ..LinearAlgebra
include(joinpath("models", "StateSelection.jl"))
import .StateSelection

model  = StateSelection.Model()
result = ModiaMath.simulate!(model, stopTime=1.0, log=true)

ModiaMath.plot(result, [:s, :sd, ("f[1]", "f[2]", "f[3]")], heading="simulationWithoutMacro/Simulate_StateSelection.jl")

end
