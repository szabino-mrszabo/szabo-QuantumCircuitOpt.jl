import QuantumCircuitOpt as QCO
using JuMP
using CPLEX
# using Cbc

include("solver.jl")

#-------------------------------#
#      User-defined inputs      #
#-------------------------------#
function target_gate()
    # return kron(QCO.U3Gate(0,0,π/4), QCO.IGate(1))
    return kron(QCO.RZGate(π/4), QCO.IGate(1))
    # return QCO.C2SXGate()
end

params = Dict{String, Any}(
"num_qubits" => 2,
"depth" => 5,

"elementary_gates" => ["RX", "RY", "RZ", "Identity"],
# "elementary_gates" => ["U3", "Identity", "cnot_12"],
# "elementary_gates" => ["H1", "H2", "T1", "T2", "T1_dagger", "T2_dagger", "cnot_12", "Identity"],  

"target_gate" => target_gate(),

"RX_discretization" => [π/4],
"RY_discretization" => [-π/4, π/4, π/2, -π/2, -π],
"RZ_discretization" => [-π/2, π/2, π/4, -π/4, -π],

"U_θ_discretization" => [-π/2, 0, π/2],
"U_ϕ_discretization" => [0, π/2],
"U_λ_discretization" => [0, π/4],

"objective" => "minimize_depth", 
"decomposition_type" => "exact",
"optimizer" => "cplex"
                            
)

#------------------------------#
#      Optimization model      #
#------------------------------#
qcm_optimizer = get_solver(params)
result_qc = QCO.run_QCModel(params, qcm_optimizer, model_type = "compact_formulation")
