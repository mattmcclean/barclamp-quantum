#
# Cookbook Name:: quantum
# Recipe:: agent
#
#

include_recipe "#{@cookbook_name}::common"

bash "install_quantum_server" do
  cwd node[:quantum][:base_dir]
  code <<-EOH
  sudo python setup_server.py install 
  EOH
  not_if ['essex-1', '2011.3', 'stable/diablo'].include?(node[:quantum][:git_revision])
end

bash "install_ovs_plugin" do
  cwd node[:quantum][:base_dir]
  code <<-EOH
  sudo python setup_openvswitch_plugin.py install 
  EOH
  not_if ['essex-1', '2011.3', 'stable/diablo'].include?(node[:quantum][:git_revision])
end

package "python-mysqldb" do
  action :install
end

template "/etc/init.d/quantum-ovs-agent" do
  source "quantum-ovs-agent.erb"
  owner "root"
  group "root"
  mode "0755" 	
end

template "#{node[:quantum][:config_dir]}/quantum/plugins/openvswitch/ovs_quantum_plugin.ini" do
  source "ovs_quantum_plugin.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  not_if ['essex-1', '2011.3', 'stable/diablo'].include?(node[:quantum][:git_revision])
  notifies :restart, "service[quantum-ovs-agent]" 
end

template "#{node[:quantum][:config_dir]}/ovs_quantum_plugin.ini" do
  source "ovs_quantum_plugin.ini.erb"
  owner "root"
  group "root"
  mode "0644"   
  only_if ['essex-1', '2011.3', 'stable/diablo'].include?(node[:quantum][:git_revision])
  notifies :restart, "service[quantum-ovs-agent]" 
end

service "quantum-ovs-agent" do
  supports :restart => true
  action :enable
end