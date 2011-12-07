define :quantum_service do

  quantum_name="quantum-#{params[:name]}"

  service quantum_name do
    if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
      restart_command "restart #{quantum_name}"
      stop_command "stop #{quantum_name}"
      start_command "start #{quantum_name}"
      status_command "status #{quantum_name} | cut -d' ' -f2 | cut -d'/' -f1 | grep start"
    end
    supports :status => true, :restart => true
    action [:enable, :start]
    subscribes :restart, resources(:template => node[:quantum][:config_file])
  end

end
