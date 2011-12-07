name "quantum-ovs-agent"
description "Quantum Openswitch Agent Role"
run_list(
         "recipe[quantum::agent]",
         "recipe[quantum::monitor]"
)
default_attributes()
override_attributes()

