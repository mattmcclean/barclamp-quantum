define :quantum_package do

  quantum_name="quantum-#{params[:name]}_#{node[:quantum][:version]}"
   
  package quantum_name

end
