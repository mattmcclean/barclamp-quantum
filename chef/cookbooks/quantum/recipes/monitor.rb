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
# Author: Matthew McClean
#

####
# if monitored by nagios, install the nrpe commands

# Nova scale data holder
quantum_scale = {
  :computes => [],
  :servers => [],
  :apis => []
}

unless node[:quantum_environment].nil?
  search(:node, "roles:nova-single-machine AND quantum_environment:#{node[:quantum_environment]}") do |n|
    quantum_scale[:computes] << n
    quantum_scale[:servers] << n
    quantum_scale[:apis] << n
  end

  search(:node, "roles:quantum-server AND quantum_environment:#{node[:quantum_environment]}") do |n|
    quantum_scale[:servers] << n
    quantum_scale[:apis] << n    
  end

  search(:node, "roles:quantum-client AND quantum_environment:#{node[:quantum_environment]}") do |n|
    quantum_scale[:apis] << n
  end
  
  search(:node, "roles:quantum-agent AND quantum_environment:#{node[:quantum_environment]}") do |n|
    quantum_scale[:computes] << n
  end  
end

template "/etc/nagios/nrpe.d/quantum_nrpe.cfg" do
  source "quantum_nrpe.cfg.erb"
  mode "0644"
  group node[:nagios][:group]
  owner node[:nagios][:user]
  variables( {
    :quantum_scale => quantum_scale
  })    
   notifies :restart, "service[nagios-nrpe-server]"
end if node["roles"].include?("nagios-client")    

