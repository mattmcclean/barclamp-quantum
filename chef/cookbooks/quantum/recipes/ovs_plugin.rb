#
# Cookbook Name:: quantum
# Recipe:: ovs_plugin
#
#

Chef::Log.info("Configuring Quantum to use openvswitch plugin")

package "python-mysqldb"

quantum_package "openvswitch-plugin"
  
mysql_connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}
  
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

template "/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini" do
  source "ovs_quantum_plugin.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[quantum-server]" 
end

