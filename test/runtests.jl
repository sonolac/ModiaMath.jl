module Runtests

import ..ModiaMath
using Test

@testset "Test ModiaMath" begin
    include(joinpath("result", "_includes.jl"))
    include(joinpath("variables", "_includes.jl"))
    include(joinpath("frames", "_includes.jl"))
    include(joinpath("nonlinearEquations", "_includes.jl"))
    include(joinpath("simulation", "_includes.jl"))

    println("\n... close all open figures.")
    ModiaMath.closeAllFigures()
end

end
