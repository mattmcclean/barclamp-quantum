DESCRIPTION
===========
Cookbook and recipes for deploying OpenStack Quantum.

REQUIREMENTS
============
Written and tested with Ubuntu 11.10 and Chef 0.10.0. 

Recipes
=======
agent
-----
Installs the quantum openvswitch agent service that runs on each nova compute node.

api
---
Installs the quantum api service.

common
------
Shared package, directories and templates for all recipes.

server
------	
Installs the Quantum Manager service.

TODO
====
- 

License
=======
Author:: Matt McClean <matt.mcclean@gmail.com>

Copyright:: 2011 Openstack

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
