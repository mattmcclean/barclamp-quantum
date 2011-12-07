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

template "/etc/quantum/plugins.ini" do
    source "plugins.ini.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, "service[quantum-server]" 
end

template "/etc/quantum/quantum.conf" do
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

node[:quantum][:monitor][:svcs] <<["quantum-server"]
