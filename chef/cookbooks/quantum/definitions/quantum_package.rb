define :quantum_package do

  quantum_name="quantum-#{params[:name]}"
  deb_name="#{quantum_name}_#{node[:quantum][:version]}.deb"

  cookbook_file "/tmp/#{deb_name}" do
    source "#{deb_name}"
    mode 0755
    owner "root"
    group "root"
  end
   
  dpkg_package quantum_name do
    source "/tmp/#{deb_name}"
    action :install
  end

end
