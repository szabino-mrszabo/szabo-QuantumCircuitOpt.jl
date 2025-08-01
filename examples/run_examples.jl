import QuantumCircuitOpt as QCOpt
using LinearAlgebra

using JuMP
using Gurobi
# using CPLEX
# using HiGHS

include("optimizers.jl")
[include("$(i)qubit_gates.jl") for i in 2:5]
include("parametrized_gates.jl")
include("decompose_all_gates.jl")

decompose_gates = [         
       
       #-- 3-qubit gates --#
        "toffoli_using_2qubit_gates",
        "CNot_1_3",
        "CNot_1_3_full",
        "fredkin",
        "toffoli_left",
        "toffoli_right",
        "miller",
        "relative_toffoli",
        "margolus",
     #  "CiSwap", # up to 1000s
        #-- 4-qubit gates --#
        "CNot_41",
        "double_peres",
        "quantum_fulladder",
        "double_toffoli",
       
        ]

decompose_gates = [ "toffoli_using_2qubit_gates"]    
#----------------------------------------------#
#      Quantum Circuit Optimization model      #
#----------------------------------------------#
qcopt_optimizer = get_gurobi(solver_log = false)

result = Dict{String,Any}()
times = zeros(length(decompose_gates), 1)

for gates = 1:length(decompose_gates)
    params = getfield(Main, Symbol(decompose_gates[gates]))()

    model_options = Dict{Symbol, Any}(
        :model_type => "compact_formulation",
        :convex_hull_gate_constraints => false,
        :idempotent_gate_constraints  => true,
        :fix_unitary_variables        => false,
        :unitary_complex_conjugate    => 2,
        :time_limit                   => 10800,
    )

    params["decomposition_type"] = "exact_optimal"
    params["objective"] = "minimize_depth"

    global result = QCOpt.run_QCModel(params, qcopt_optimizer; options = model_options)
    times[gates] = result["solve_time"]
end
