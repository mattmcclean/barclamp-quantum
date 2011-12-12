#
# Cookbook Name:: quantum	
# Recipe:: client
#
#

include_recipe "#{@cookbook_name}::common"

qservers = search(:node, "roles:quantum-server") || []
if qservers.length > 0
  qserver = qservers[0]
  qserver = node if qserver.name == node.name
else
  qserver = node	
end

qserver_address = Chef::Recipe::Barclamp::Inventory.get_network_by_type(qserver, "admin").address if qserver_address.nil?    
qserver_port = qserver[:quantum][:server][:bind_port]
Chef::Log.info("Quantum server found at #{qserver_address} and listening on port: #{qserver_port}")  

template "#{node[:quantum][:client][:config_file]}" do
  source "quantum.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables({
	:verbose      => node[:quantum][:client][:verbose],
	:debug        => node[:quantum][:client][:debug],
	:bind_host    => qserver_address,
	:bind_address => qserver_port
  })   
end


