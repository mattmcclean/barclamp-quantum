#
# Cookbook Name:: quantum
# Recipe:: api
#
#

include_recipe "#{@cookbook_name}::common"

bash "install_quantum_client" do
  cwd node[:quantum][:base_dir]
  code <<-EOH
  sudo python setup_client.py install 
  EOH
  not_if ['essex-1', '2011.3', 'stable/diablo'].include?(node[:quantum][:git_revision])
end

template "#{node[:quantum][:config_dir]}/quantum.conf" do
  source "quantum.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end


