#
# Cookbook Name:: quantum
# Recipe:: common
#
#

include_recipe "python"
    
package "python-setuptools"

cookbook_file "/tmp/pip-requires" do
  source "pip-requires"
  mode 0755
  owner "root"
  group "root"
end
			
bash "install_pips" do
  code <<-EOH
  sudo pip install `cat /tmp/pip-requires` 
  EOH
end	if File.exist?("/tmp/pip-requires")
	
quantum_package "common"



