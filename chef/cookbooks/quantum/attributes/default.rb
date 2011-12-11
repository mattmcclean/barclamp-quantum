# Copyright 2011, Matthew McClean, Inc.
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

# declare what needs to be monitored
node[:quantum][:monitor]={}
node[:quantum][:monitor][:svcs] = []
node[:quantum][:monitor][:ports]={}

default[:quantum][:deb_repository] = "http://dl.dropbox.com/u/3256948/"
default[:quantum][:version] = "2012.1dev-2_all"

default[:quantum][:verbose] = true
default[:quantum][:debug] = true
default[:quantum][:api_bind_host] = "0.0.0.0"
default[:quantum][:api_bind_port] = "9696"

default[:quantum][:server][:plugin][:name] = "openvswitch"
default[:quantum][:server][:plugin][:module] = "quantum.plugins.openvswitch.ovs_quantum_plugin.OVSQuantumPlugin"
default[:quantum][:server][:plugin][:ovs][:database] = "ovs_quantum"
default[:quantum][:server][:plugin][:ovs][:db][:user] = "quantum"
default[:quantum][:server][:plugin][:ovs][:db][:password] = "quantum"