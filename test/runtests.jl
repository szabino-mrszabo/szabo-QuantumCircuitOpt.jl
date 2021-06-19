using QuantumCircuitOpt
using Memento
using JuMP
using LinearAlgebra
using Test
using Cbc

const QCO = QuantumCircuitOpt
const LA = LinearAlgebra

# Suppress warnings during testing
QCO.logger_config!("error")

const CBC = JuMP.optimizer_with_attributes(Cbc.Optimizer,  MOI.Silent() => true)

@testset "QuantumCircuitOpt" begin

    include("utility_tests.jl")
    include("data_tests.jl")
    include("qc_model_tests.jl")
    include("relaxations_tests.jl")

end