name "quantum-server"
description "Quantum Server Role"
run_list(
         "recipe[quantum::client]",
         "recipe[quantum::server]",
         "recipe[quantum::monitor]"
)
default_attributes()
override_attributes()

