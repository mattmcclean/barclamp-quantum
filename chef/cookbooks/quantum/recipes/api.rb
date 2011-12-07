#
# Cookbook Name:: quantum	
# Recipe:: api
#
#

include_recipe "#{@cookbook_name}::common"

quantum_service "client"


