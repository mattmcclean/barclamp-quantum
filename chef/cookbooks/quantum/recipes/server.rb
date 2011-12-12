#
# Cookbook Name:: quantum
# Recipe:: server
#
#

include_recipe "#{@cookbook_name}::common"

quantum_package "server"

if node[:quantum][:server][:plugin][:name] == "openvswitch"

  include_recipe "#{@cookbook_name}::ovs_plugin"

elsif node[:quantum][:server][:plugin][:name] == "cisco"

  include_recipe "#{@cookbook_name}::cisco_plugin"
  
else

  include_recipe "#{@cookbook_name}::sample_plugin"

end  

template "#{node[:quantum][:server][:plugin_ini_file]}" do
    source "plugins.ini.erb"
    owner "root"
    group "root"
    mode "0644"    
    notifies :restart, "service[quantum-server]" 
end

# Make sure we use the admin node for now.
my_ipaddress = Chef::Recipe::Barclamp::Inventory.get_network_by_type(node, "admin").address
node[:quantum][:server][:bind_host] = my_ipaddress
node.save

template "#{node[:quantum][:server][:config_file]}" do
  source "quantum.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables({
	:verbose      => node[:quantum][:server][:verbose],
	:debug        => node[:quantum][:server][:debug],
	:bind_host    => node[:quantum][:server][:bind_host],
	:bind_port => node[:quantum][:server][:bind_port]
  })   
  notifies :restart, "service[quantum-server]"  
end

service "quantum-server" do
  supports :restart => true
  action :enable
end

node[:quantum][:monitor][:svcs] <<["quantum-server"]
node[:quantum][:monitor][:ports] <<[node[:quantum][:server][:bind_port]]