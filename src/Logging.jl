# License for module ModiaMath.Logging: MIT
# Copyright 2017-2018, DLR Institute of System Dynamics and Control


"""
    module ModiaMath.Logger

Log model evaluations.


# Main developer
Martin Otter, [DLR - Institute of System Dynamics and Control](https://www.dlr.de/sr/en)
"""
module Logging
@eval using Printf

import ..TypesAndStructs: Logger, SimulationStatistics

export setLog!, setAllLogCategories!, setLogCategories!
export isLogStatistics, isLogProgress, isLogInfos, isLogWarnings, isLogEvents
export logOn!, logOff!, setLogCategories
export reInitializeStatistics!, set_nResultsForSimulationStatistics!

function setLog!(logger::Logger, log::Bool)
    logger.log = log
    return nothing
end

function setAllLogCategories!(logger::Logger; default=true)
    logger.statistics = default
    logger.progress   = default
    logger.infos      = default
    logger.warnings   = default
    logger.events     = default
end


"""
    ModiaMath.setLogCategories!(obj, categories; reinit=true)

Set log categories on obj (of type ModiaMath.SimulationState, ModiaMath.AbstractSimulationModel,
or ModiaMath.Logger) as vector of symbols, e.g. setLogCategories!(simulationModel, [:LogProgess]).
Supported categories:
- `:LogStatistics`, print statistics information at end of simulation
- `:LogProgress`, print progress information during simulation
- `:LogInfos`, print information messages of the model
- `:LogWarnings`, print warning messages of the model
- `:LogEvents`, log events of the model

If option reinit=true, all previous set categories are reinitialized to be no longer present.
If reinit=false, previously set categories are not changed.
"""
function setLogCategories!(logger::Logger, categories::Vector{Symbol}; reinit=true)
    if reinit
        setAllLogCategories!(logger;default=false)
    end

    for c in categories
        if c == :LogStatistics
            logger.statistics = true
        elseif c == :LogProgress
            logger.progress = true
        elseif c == :LogInfos
            logger.infos = true
        elseif c == :LogWarnings
            logger.warnings = true
        elseif c == :LogEvents
            logger.events = true
        else
            warning("Log categorie ", c, " not known (will be ignored)")
        end
    end
    return nothing
end



"""
    ModiaMath.logOn!(obj)

Enable logging on `obj` (of type ModiaMath.SimulationState, ModiaMath.AbstractSimulationModel,
or ModiaMath.Logger)
"""
function logOn!(logger::Logger)
    logger.log = true
    return nothing
end


"""
    ModiaMath.logOff!(obj)

Disable logging on `obj` (of type ModiaMath.SimulationState, ModiaMath.AbstractSimulationModel,
or ModiaMath.Logger)
"""
function logOff!(logger::Logger)
    logger.log = false
    return nothing
end


"""
    ModiaMath.isLogStatistics(logger::ModiaMath.Logger)

Return true, if logger settings require to print **statistics** messages of the model.
"""
isLogStatistics(logger::Logger) = logger.log && logger.statistics


"""
    ModiaMath.isLogProgress(logger::ModiaMath.Logger)

Return true, if logger settings require to print **progress** messages of the model
"""
isLogProgress(logger::Logger) = logger.log && logger.progress


"""
    ModiaMath.isLogInfos(obj)

Return true, if logger settings require to print **info** messages of the model
(obj must be of type ModiaMath.SimulationState, ModiaMath.AbstractSimulationModel,
or ModiaMath.Logger).
"""
isLogInfos(logger::Logger)      = logger.log && logger.infos


"""
    ModiaMath.isLogWarnings(obj)

Return true, if logger settings require to print **warning** messages of the model
(obj must be of type ModiaMath.SimulationState, ModiaMath.AbstractSimulationModel,
or ModiaMath.Logger).
"""
isLogWarnings(logger::Logger)   = logger.log && logger.warnings


"""
    ModiaMath.isLogEvents(obj)

Return true, if logger settings require to print **event** messages of the model
(obj must be of type ModiaMath.SimulationState, ModiaMath.AbstractSimulationModel,
or ModiaMath.Logger).
"""
isLogEvents(logger::Logger)     = logger.log && logger.events

function reInitializeStatistics!(stat::SimulationStatistics,
                                 startTime::Float64, stopTime::Float64, interval::Float64, tolerance::Float64)
    stat.cpuTimeInitialization = 0.0
    stat.cpuTimeIntegration    = 0.0
    stat.startTime      = startTime
    stat.stopTime       = stopTime
    stat.interval       = interval
    stat.tolerance      = tolerance
    stat.nResults       = 0
    stat.nSteps         = 0
    stat.nResidues      = 0
    stat.nZeroCrossings = 0
    stat.nJac           = 0
    stat.nTimeEvents    = 0
    stat.nStateEvents   = 0
    stat.nRestartEvents = 0
    stat.nErrTestFails  = 0
    stat.h0             = floatmax(Float64)
    stat.hMin           = floatmax(Float64)
    stat.hMax           = 0.0
    stat.orderMax       = 0
end


import Base.show
Base.print(io::IO, stat::SimulationStatistics) = show(io, stat)

function Base.show(io::IO, stat::SimulationStatistics)
    println(io, "        structureOfDAE = ", stat.structureOfDAE)
    @printf(io, "        cpuTime        = %.2g s (init: %.2g s, integration: %.2g s)\n",
                                           stat.cpuTimeInitialization + stat.cpuTimeIntegration,
                                           stat.cpuTimeInitialization, stat.cpuTimeIntegration)
    println(io, "        startTime      = ", stat.startTime, " s")
    println(io, "        stopTime       = ", stat.stopTime, " s")
    println(io, "        interval       = ", stat.interval, " s")
    println(io, "        tolerance      = ", stat.tolerance)
    println(io, "        nEquations     = ", stat.nEquations, typeof(stat.nConstraints)!=Missing ?
                                                                  " (includes " * string(stat.nConstraints) * " constraints)" : "" )
    println(io, "        nResults       = ", stat.nResults)
    println(io, "        nSteps         = ", stat.nSteps)
    println(io, "        nResidues      = ", stat.nResidues, " (includes residue calls for Jacobian)")
    println(io, "        nZeroCrossings = ", stat.nZeroCrossings)
    println(io, "        nJac           = ", stat.nJac)
    println(io, "        nTimeEvents    = ", stat.nTimeEvents)
    println(io, "        nStateEvents   = ", stat.nStateEvents)
    println(io, "        nRestartEvents = ", stat.nRestartEvents)
    println(io, "        nErrTestFails  = ", stat.nErrTestFails)
    @printf(io, "        h0             = %.2g s\n", stat.h0)
    @printf(io, "        hMin           = %.2g s\n", stat.hMin)
    @printf(io, "        hMax           = %.2g s\n", stat.hMax)
    println(io, "        orderMax       = ", stat.orderMax)
    println(io, "        sparseSolver   = ", stat.sparseSolver)

    if stat.sparseSolver
        println(io, "        nGroups        = ", stat.nGroups)
    end
end


function set_nResultsForSimulationStatistics!(stat::SimulationStatistics, nt::Int)
    stat.nResults = nt
    return nothing
end


end
