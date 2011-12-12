# Copyright 2011, Matthew McClean
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

override[:quantum][:user]="quantum"

default[:quantum][:deb_repository] = "http://dl.dropbox.com/u/3256948/"
default[:quantum][:version] = "2012.1dev-2_all"
default[:quantum][:sql_idle_timeout]: 3600
default[:quantum][:use_keystone]: true
default[:quantum][:keystone_instance]: "none"
default[:quantum][:database_type]: "mysql"
default[:quantum][:database_name]: "ovs_quantum"
default[:quantum][:mysql_instance]: "none"  
default[:quantum][:database_port]: "3306"  

default[:quantum][:client][:verbose] = "True"
default[:quantum][:client][:debug] = "True"
default[:quantum][:client][:log_file] = "/var/log/quantum/quantum-client.log"
default[:quantum][:client][:config_file] = "/etc/quantum/quantum.conf"
default[:quantum][:client][:server_instance] = "none"

default[:quantum][:server][:verbose] = "True"
default[:quantum][:server][:debug] = "True"
default[:quantum][:server][:bind_host] = ipaddress
default[:quantum][:server][:bind_port] = "9696"
default[:quantum][:server][:log_file] = "/var/log/quantum/quantum-server.log"
default[:quantum][:server][:config_file] = "/etc/quantum/quantum.conf"
default[:quantum][:server][:plugin_ini_file] = "/etc/quantum/plugin.ini"

default[:quantum][:server][:plugin][:name] = "openvswitch"
default[:quantum][:server][:plugin][:module] = "quantum.plugins.openvswitch.ovs_quantum_plugin.OVSQuantumPlugin"
default[:quantum][:server][:plugin][:ovs][:db_user] = "quantum"
default[:quantum][:server][:plugin][:ovs][:db_password] = "quantum"
default[:quantum][:server][:plugin][:ovs][:config_file] = "/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini"

default[:quantum][:ovs_agent][:verbose] = "True"
default[:quantum][:ovs_agent][:debug] = "True"
default[:quantum][:ovs_agent][:agent_script_dir] = "/etc/quantum/plugins/openvswitch/agent"
default[:quantum][:ovs_agent][:agent_script] = "/etc/quantum/plugins/openvswitch/agent/ovs_quantum_agent.py"
default[:quantum][:ovs_agent][:log_file] =  "/var/log/quantum/ovs_agent.log"
default[:quantum][:ovs_agent][:config_file] =  "/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini"
default[:quantum][:ovs_agent][:db_user] = "quantum"
default[:quantum][:ovs_agent][:db_password] = "quantum"

# declare what needs to be monitored
node[:quantum][:monitor]={}
node[:quantum][:monitor][:svcs] = []
node[:quantum][:monitor][:ports]={}
