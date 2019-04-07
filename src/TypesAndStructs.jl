"""
    module Structs

Contains all the structs in ModiaMath
"""
module TypesAndStructs

# Types
export AbstractSimulationModel
"""
    type ModiaMath.AbstractSimulationModel

Struct that is used as simulation model (has field: simulationState)
"""
abstract type AbstractSimulationModel end



export AbstractComponentWithVariables
"""
    type ModiaMath.AbstractComponentWithVariables

Struct that contains ModiaMath.AbstractVariables as field or as field
in a sub-struct.
"""
abstract type AbstractComponentWithVariables end



export AbstractComponentInternal
" The internal part of a component (has at least fields \"name\" and \"within\") "
abstract type AbstractComponentInternal end



export AbstractVariable
"""
    type ModiaMath.AbstractVariable <: ModiaMath.AbstractComponentWithVariables

A Variable used as element of the DAE model description and is
included in the result (if no residue)
"""
abstract type AbstractVariable <: AbstractComponentWithVariables end



export AbstractRealVariable
"""
    ModiaMath.AbstractRealVariable <: ModiaMath.AbstractVariable

A real [`ModiaMath.AbstractVariable`](@ref) (either scalar or array)
"""
abstract type AbstractRealVariable <: AbstractVariable end

# Use by Logger only
export Logger
"""
    mutable struct Logger - Log model evaluations
"""
mutable struct Logger
    log::Bool           # = true, if logging

    # log categories
    statistics::Bool
    progress::Bool
    infos::Bool
    warnings::Bool
    events::Bool

    Logger() = new(false, true, true, true, true, true)
end


export SimulationStatistics
"""
    mutable struct SimulationStatistics - Collect statistics of the last simulation run.

The following data is stored in this structure:

- `structureOfDAE`: Structure of DAE
- `cpuTimeInitialization`: CPU-time for initialization
- `cpuTimeIntegration`: CPU-time for integration
- `startTime`: start time of the integration
- `stopTime`: stop time of the integration
- `interval`: communication interval of the integration
- `tolerance`: relative tolerance used for the integration
- `nEquations`: number of equations (length of y and of yp)
- `nConstraints`: number of constraint equations
- `nResults`: number of time points stored in result data structure
- `nSteps`: number of (successful) steps
- `nResidues`: number of calls to compute residues (includes residue calls for Jacobian)
- `nZeroCrossing`: number of calls to compute zero crossings
- `nJac`: number of calls to compute Jacobian
- `nTimeEvents`: number of time events
- `nRestartEvents`: number of events with integrator restart
- `nErrTestFails`: number of fails of error tests
- `h0`: stepsize used at the first step
- `hMin`: minimum integration stepsize
- `hMax`: maximum integration stepsize
- `orderMax`: maximum integration order
- `sparseSolver` = true: if sparse solver used, otherwise dense solver
- `nGroups`: if sparseSolver, number of column groups to compute Jacobian
  (e.g. if nEquations=100, nGroups=5, then 5+1=6 model evaluations are needed
  to compute the Jacobian numerically, instead of 101 model evaluations without
  taking the sparseness structure into account).
"""
mutable struct SimulationStatistics
    structureOfDAE::Any
    cpuTimeInitialization::Float64
    cpuTimeIntegration::Float64
    startTime::Float64
    stopTime::Float64
    interval::Float64
    tolerance::Float64
    nEquations::Int
    nConstraints::Union{Int,Missing}
    nResults::Int
    nSteps::Int
    nResidues::Int
    nZeroCrossings::Int
    nJac::Int
    nTimeEvents::Int
    nStateEvents::Int
    nRestartEvents::Int
    nErrTestFails::Int
    h0::Float64
    hMin::Float64
    hMax::Float64
    orderMax::Int
    sparseSolver::Bool
    nGroups::Int

    SimulationStatistics(structureOfDAE, nEquations::Int, nConstraints::Union{Int,Missing}, sparseSolver::Bool, nGroups::Int) =
    new(structureOfDAE, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, nEquations, nConstraints, 0, 0, 0, 0, 0, 0, 0, 0, 0, floatmax(Float64),
        floatmax(Float64), 0.0, 0, sparseSolver, nGroups)
end


end
