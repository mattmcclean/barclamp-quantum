#
# Cookbook Name:: quantum
# Recipe:: cisco_plugin
#
#

Chef::Log.info("Configuring Quantum to use Cisco plugin")

quantum_package "cisco-plugin"
  

