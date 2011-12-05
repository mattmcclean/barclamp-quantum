name "quantum-client"

description "Installs requirements to run the Quantum client"
run_list(
         "recipe[quantum::api]"
         "recipe[quantum::monitor]"
         )
