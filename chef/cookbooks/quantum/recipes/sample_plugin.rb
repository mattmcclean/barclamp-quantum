#
# Cookbook Name:: quantum
# Recipe:: sample_plugin
#
#

Chef::Log.info("Configuring Quantum to use sample plugin")

quantum_package "sample-plugin"
  

