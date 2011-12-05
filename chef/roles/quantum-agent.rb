name "quantum-agent"

description "Installs requirements to run the Quantum Agent on Nova Compute node"
run_list(
         "recipe[quantum::agent]",
         "recipe[quantum::monitor]"
         )
