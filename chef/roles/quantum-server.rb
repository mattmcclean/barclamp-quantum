name "quantum-server"
description "Installs requirements to run a Quantum Server"
run_list(
         "recipe[quantum::api]",
         "recipe[quantum::server]",
         "recipe[quantum::monitor]"
         )
