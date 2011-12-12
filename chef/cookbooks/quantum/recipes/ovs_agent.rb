#
# Cookbook Name:: quantum
# Recipe:: ovs_agent
#
#

include_recipe "#{@cookbook_name}::common"

package "linux-headers-#{node.os_version}"

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

if node[:quantum][:database_type] == "mysql"

  Chef::Log.info("Configuring openvswitch agent to use MySQL backend")

  inclide_recipe "mysql::client"
  
  package "python-mysqldb"
  
  env_filter = " AND mysql_config_environment:mysql-config-#{node[:quantum][:mysql_instance]}"
  mysqls = search(:node, "roles:mysql-server#{env_filter}") || []
  if mysqls.length > 0
	mysql = mysqls[0]
	mysql = node if mysql.name == node.name
  else
	mysql = node	
  end

  mysql_address = Chef::Recipe::Barclamp::Inventory.get_network_by_type(mysql, "admin").address if mysql_address.nil?    
  Chef::Log.info("Mysql server found at #{mysql_address}")  
  
  template "#{node[:quantum][:ovs_agent][:config_file]}" do
    source "ovs_quantum_plugin.ini.erb"
    owner "root"
    group "root"
    mode "0644"
	variables( {
		:db_name => node[:quantum][:database_name],
		:db_user => node[:quantum][:ovs_agent][:db_user],
		:db_pass => node[:quantum][:ovs_agent][:db_password],
		:db_host => mysql_address,
		:db_port => node[:quantum][:database_port]
	})       
    notifies :restart, "service[quantum-ovs-agent]" 
  end    
  
end

directory "#{node[:quantum][:ovs_agent][:agent_script_dir]}"

cookbook_file "#{node[:quantum][:ovs_agent][:agent_script]}" do
  source "ovs_agent/ovs_quantum_agent.py"
end

template "/etc/init.d/quantum-ovs-agent" do
  source "quantum-ovs-agent.erb"
  owner "root" 
  group "root"
  mode "0755" 	
end

service "quantum-ovs-agent" do
  supports :restart => true
  action :enable
end

node[:quantum][:monitor][:svcs] <<["ovs_quantum_agent"]