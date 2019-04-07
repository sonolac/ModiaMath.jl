module test_Plot4

import ..ModiaMath
using Test
using Unitful
t = range(0.0, stop=10.0, length=100)

result = Dict{AbstractString,Any}()
result["time"] = t * u"s"
result["phi"]  = sin.(t)u"rad"
result["phi2"] = 0.5 * sin.(t)u"rad"
result["w"]    = cos.(t)u"rad/s"
result["w2"]   = 0.6 * cos.(t)u"rad/s"
result["r"]    = hcat(0.4 * cos.(t), 0.5 * sin.(t), 0.3*cos.(t))
result["r2"]   = hcat(0.1*cos.(t), 0.2*cos.(t), 0.3*cos.(t), 0.4*cos.(t), 0.5*cos.(t),
                      0.6*cos.(t), 0.7*cos.(t), 0.8*cos.(t), 0.9*cos.(t), 1.0*cos.(t), 1.1*cos.(t))

ModiaMath.plot(result, [ (:phi), (:phi, :phi2, :w), (:w, :w2) ], heading="Vector of plots")

ModiaMath.plot(result, [ "r", "r2[3]", "r2"], heading="Vector of plots", figure=2)

# Print result variables
println("\n... result variables = ", ModiaMath.resultTable(result))

end
