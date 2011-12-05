#
# Cookbook Name:: quantum
# Attributes:: default
#
#

default[:quantum][:git_revision] = "essex-1"
default[:quantum][:git_url] = "https://github.com/openstack/quantum.git"
default[:quantum][:base_dir] = "/opt/quantum"
default[:quantum][:config_dir] = "/opt/quantum/etc"
default[:quantum][:plugin][:config_dir] = "/opt/quantum/etc/quantum/plugins/openvswitch"
default[:quantum][:plugin][:lib_dir] = "/opt/quantum/quantum/plugins/openvswitch"

default[:quantum][:verbose] = "True"
default[:quantum][:debug] = "True"
default[:quantum][:bind_host] = "0.0.0.0"
default[:quantum][:bind_port] = "9696"

default[:quantum][:server][:plugin][:name] = "openvswitch"
default[:quantum][:server][:plugin][:module] = "quantum.plugins.openvswitch.ovs_quantum_plugin.OVSQuantumPlugin"
default[:quantum][:server][:plugin][:ovs][:database] = "ovs_quantum"
default[:quantum][:server][:plugin][:ovs][:db][:user] = "quantum"
default[:quantum][:server][:plugin][:ovs][:db][:password] = "quantum"
default[:quantum][:server][:plugin][:ovs][:db][:host] = "localhost"
default[:quantum][:server][:plugin][:ovs][:db][:port] = "3306"
