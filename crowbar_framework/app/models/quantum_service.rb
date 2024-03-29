# Copyright 2011, Matthew McClean 
# 
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at 
# 
#  http://www.apache.org/licenses/LICENSE-2.0 
# 
# Unless required by applicable law or agreed to in writing, software 
# distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and 
# limitations under the License. 
# 

class QuantumService < ServiceObject

  def initialize(thelogger)
    @bc_name = "quantum"
    @logger = thelogger
  end
  
  #if barclamp allows multiple proposals OVERRIDE
  # def self.allow_multiple_proposals?
  
  def create_proposal
    @logger.debug("Quantum create_proposal: entering")
    base = super

    nodes = NodeObject.all
    nodes.delete_if { |n| n.nil? or n.admin? }
    if nodes.size >= 1
      base["deployment"]["quantum"]["elements"] = {
        "quantum-server" => [ nodes.first[:fqdn] ]
      }
    end

    base["attributes"]["quantum"]["mysql_instance"] = ""
    begin
      mysqlService = MysqlService.new(@logger)
      mysqls = mysqlService.list_active[1]
      if mysqls.empty?
        # No actives, look for proposals
        mysqls = mysqlService.proposals[1]
      end
      if mysqls.empty?
        base["attributes"]["quantum"]["database"] = "sqlite"
      else
        base["attributes"]["quantum"]["mysql_instance"] = mysqls[0]
        base["attributes"]["quantum"]["database"] = "mysql"
      end
    rescue
      base["attributes"]["quantum"]["database"] = "sqlite"
      @logger.info("Quantum create_proposal: no mysql found")
    end

    @logger.debug("Quantum create_proposal: exiting")
    base
  end

  def apply_role_pre_chef_call(old_role, role, all_nodes)
    @logger.debug("Quantum apply_role_pre_chef_call: entering #{all_nodes.inspect}")
    return if all_nodes.empty?

    # Make sure the bind hosts are in the admin network
    all_nodes.each do |n|
      node = NodeObject.find_node_by_name n

      admin_address = node.get_network_by_type("admin")["address"]
      node.crowbar[:quantum] = {} if node.crowbar[:quantum].nil?
      node.crowbar[:quantum][:api_bind_host] = admin_address

      node.save
    end
    @logger.debug("Quantum apply_role_pre_chef_call: leaving")
  end

end

