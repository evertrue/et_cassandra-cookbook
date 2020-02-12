#
# Cookbook Name:: et_cassandra
# Recipe:: search_discovery
#
# Copyright (c) 2014 EverTrue, Inc., All Rights Reserved.

nodes = search(
  :node,
  node['et_cassandra']['discovery']['topo_search_str'] +
  " AND chef_environment:#{node.chef_environment}",
  filter_result: {
    'ip' => %w(ipaddress),
    'az' => %w(ec2 placement_availability_zone)
  }
)

topology = nodes.each_with_object({}) do |n, m|
  n_d = Chef::VersionConstraint.new('< 12.1.1').include?(Chef::VERSION) ? n['data'] : n
  region = n_d['az'][0..-2]
  az     = n_d['az'][-1, 1]

  m[region] ||= {}
  m[region][az] ||= []
  m[region][az] << n_d['ip']
end

current_node_region = node['ec2']['placement_availability_zone'][0..-2]
current_node_az     = node['ec2']['placement_availability_zone'][-1, 1]

# If this is the only node, and thus `topology` is empty, ensure we have the
# necessary structures in place
topology[current_node_region] ||= {}
topology[current_node_region][current_node_az] ||= []
topology[current_node_region][current_node_az] << node['ipaddress']

# Ensure we don't have any duplicate entries after first convergence
topology[current_node_region][current_node_az] = topology[current_node_region][current_node_az].uniq

%w(
  yaml
).each do |ext|
  template "/etc/cassandra/cassandra-topology.#{ext}" do
    variables topology: topology
  end
end

template '/etc/cassandra/cassandra-rackdc.properties' do
  variables(
    topology: {
      dc: current_node_region,
      rac: current_node_az
    }
  )
end
