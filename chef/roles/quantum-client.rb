name "quantum-client"
description "Quantum Client Role"
run_list(
         "recipe[quantum::client]"
)
default_attributes()
override_attributes()

