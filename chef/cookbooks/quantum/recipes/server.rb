#
# Cookbook Name:: quantum
# Recipe:: server
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

bash "install_openvswitch_plugin" do
  cwd node[:quantum][:base_dir]
  code <<-EOH
  sudo python setup_openvswitch_plugin.py install 
  EOH
  not_if ['essex-1', '2011.3', 'stable/diablo'].include?(node[:quantum][:git_revision])
end

if node[:quantum][:server][:plugin][:name] == "openvswitch"

  Chef::Log.info("Configuring Quantum to use MySQL backend")
  package "python-mysqldb" do
    action :install
  end
  
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

  template "#{node[:quantum][:config_dir]}/quantum/plugins/openvswitch/ovs_quantum_plugin.ini" do
    source "ovs_quantum_plugin.ini.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, "service[quantum-server]" 
    not_if ['essex-1', '2011.3', 'stable/diablo'].include?(node[:quantum][:git_revision])
  end

  template "#{node[:quantum][:config_dir]}/ovs_quantum_plugin.ini" do
    source "ovs_quantum_plugin.ini.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, "service[quantum-server]"     
    only_if ['essex-1', '2011.3', 'stable/diablo'].include?(node[:quantum][:git_revision])
  end

end  

template "/etc/init.d/quantum-server" do
  source "quantum-server.erb"
  owner "root"
  group "root"
  mode "0755" 	
end

template "#{node[:quantum][:config_dir]}/plugins.ini" do
    source "plugins.ini.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, "service[quantum-server]" 
end

template "#{node[:quantum][:config_dir]}/quantum.conf" do
  source "quantum.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[quantum-server]"  
end

service "quantum-server" do
  supports :restart => true
  action :enable
end

