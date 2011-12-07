name "quantum-server"
description "Quantum Server Role"
run_list(
         "recipe[quantum::api]",
         "recipe[quantum::server]",
         "recipe[quantum::monitor]"
)
default_attributes()
override_attributes()

