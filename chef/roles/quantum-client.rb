name "quantum-client"
description "Quantum Client Role"
run_list(
         "recipe[quantum::api]"
)
default_attributes()
override_attributes()

