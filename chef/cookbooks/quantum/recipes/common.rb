#
# Cookbook Name:: quantum
# Recipe:: common
#
#

include_recipe "python"
    
package "python-setuptools" do
  action :install
end

package "python-dev" do
  action :install
end

package "python-virtualenv" do
  action :install
end   

package "git" do
  action :install
end  
    
git node[:quantum][:base_dir] do
  repository node[:quantum][:git_url]
  revision node[:quantum][:git_revision]
  action :sync
end  
	
# bash "install_pips" do
#  user "root"
#  cwd node[:quantum][:base_dir]
#  code <<-EOH
#  sudo pip install `cat #{node[:quantum][:base_dir]}/tools/pip-requires` 
#  EOH
# end	
	
#if File.exist?("/opt/quantum/tools/pip-requires")
#
  # Install each pip entry that exists in the pip_requires file
#  File.open("/opt/quantum/tools/pip-requires").each_line do |line|
#
#    python_pip line do
#      action :install
#    end
#  end
#end

if ['essex-1', '2011.3', 'stable/diablo'].include?(node[:quantum][:git_revision])
	bash "install_quantum" do
	  cwd node[:quantum][:base_dir]
	  code <<-EOH
	  sudo python setup.py install 
	  EOH
	end
else
	bash "install_quantum_common" do
	  cwd node[:quantum][:base_dir]
	  code <<-EOH
	  sudo python setup_common.py install
	  EOH
	end
end



