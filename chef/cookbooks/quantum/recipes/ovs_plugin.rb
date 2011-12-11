#
# Cookbook Name:: quantum
# Recipe:: ovs_plugin
#
#

Chef::Log.info("Configuring Quantum to use openvswitch plugin")

bash "install linux headers" do
  code <<-EOH
  sudo apt-get install -y linux-headers-${uname -r}
  EOH
end

package "openvswitch-switch"

package "openvswitch-datapath-dkms"

quantum_package "openvswitch-plugin"
 
if node[:quantum][:server][:plugin][:ovs][:sql_engine] == "mysql"
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

	mysql_connection_info = {:host => mysql_address, :username => "db_maker", :password => mysql[:mysql][:db_maker_password]}
	  
	# Create the Quantum Database
	mysql_database node[:quantum][:server][:plugin][:ovs][:database] do
	  connection mysql_connection_info
	  action :create
	end
	
	mysql_database_user node[:quantum][:server][:plugin][:ovs][:db][:user] do
	  connection mysql_connection_info
	  password node[:quantum][:server][:plugin][:ovs][:db][:password]
	  action :create
	end
	
	mysql_database_user node[:quantum][:server][:plugin][:ovs][:db][:user] do
	  connection mysql_connection_info
	  password node[:quantum][:server][:plugin][:ovs][:db][:password]
	  database_name node[:quantum][:server][:plugin][:ovs][:database]
	  host '%'
	  action :grant
	end
end 
 
template "/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini" do
  source "ovs_quantum_plugin.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[quantum-server]" 
end

