define :quantum_package do

  quantum_name="quantum-#{params[:name]}"
  
  deb_name="#{quantum_name}_#{node[:quantum][:version]}.deb"

  Chef::Log.info("Installing deb package #{deb_name} from remote repository #{node[:quantum][:deb_repository]}")

  remote_file "/tmp/#{deb_name}" do
    source "#{node[:quantum][:deb_repository]}#{deb_name}"
    mode 0755
    owner "root"
    group "root"
  end
   
  dpkg_package quantum_name do
    source "/tmp/#{deb_name}"
    action :install
  end

end
