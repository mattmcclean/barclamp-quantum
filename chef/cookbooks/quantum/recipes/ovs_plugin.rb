#
# Cookbook Name:: quantum
# Recipe:: ovs_plugin
#
#

Chef::Log.info("Configuring Quantum to use openvswitch plugin")

quantum_package "openvswitch-plugin"
 
if node[:quantum][:database_type] == "mysql"

    Chef::Log.info("Configuring Quantum to use MySQL backend")

    include_recipe "mysql::client"

    package "python-mysqldb" do
        action :install
    end

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
  
    template "#{node[:quantum][:server][:plugin][:ovs][:config_file]}" do
	  source "ovs_quantum_plugin-server.ini.erb"
	  owner "root"
	  group "root"
	  mode "0644"
	  variables( {
		:db_name => node[:quantum][:database_name],
		:db_user => node[:quantum][:server][:plugin][:ovs][:db_user],
		:db_pass => node[:quantum][:server][:plugin][:ovs][:db_password],
		:db_host => mysql_address,
		:db_port => node[:quantum][:database_port]
	  })   
	  notifies :restart, "service[quantum-server]" 
	end
  	
end 
 


