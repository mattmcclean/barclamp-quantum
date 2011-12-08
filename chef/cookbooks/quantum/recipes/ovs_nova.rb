#
# Cookbook Name:: quantum
# Recipe:: ovs_nova
#
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

# install linux headers file
bash "install_linux_headers" do
	code <<-EOH
	sudo apt-get install -y linux-headers-$(uname -r) 
	EOH
end if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)

package "openvswitch-switch"

package "openvswitch-datapath-dkms"

# Set up integration bridge
bash "setup_integration_bridge" do
	code <<-EOH
	OVS_BRIDGE=${OVS_BRIDGE:-br-int}
	sudo ovs-vsctl --no-wait -- --if-exists del-br $OVS_BRIDGE
	sudo ovs-vsctl --no-wait add-br $OVS_BRIDGE
	sudo ovs-vsctl --no-wait br-set-external-id $OVS_BRIDGE bridge-id br-int
	EOH
end
  