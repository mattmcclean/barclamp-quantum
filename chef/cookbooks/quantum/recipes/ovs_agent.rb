#
# Cookbook Name:: quantum
# Recipe:: ovs_agent
#
#

include_recipe "#{@cookbook_name}::common"

package "python-mysqldb"

directory "/etc/quantum/plugins/openvswitch/agent"

cookbook_file "/etc/quantum/plugins/openvswitch/agent/ovs_quantum_agent.py" do
  source "ovs_agent/ovs_quantum_agent.py"
end

cookbook_file "/etc/init.d/quantum-ovs-agent" do
  source "ovs_agent/quantum-ovs-agent"
  owner "root"
  group "root"
  mode "0755" 	
end

template "/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini" do
  source "ovs_quantum_plugin.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[quantum-ovs-agent]" 
end

service "quantum-ovs-agent" do
  supports :restart => true
  action :enable
end

node[:quantum][:monitor][:svcs] <<["ovs_quantum_agent"]