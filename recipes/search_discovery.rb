#
# Cookbook Name:: et_cassandra
# Recipe:: search_discovery
#
# Copyright (c) 2014 EverTrue, Inc., All Rights Reserved.

topology_analogs = {
  dc: {
    'us-east-1'      => 'dc1',
    'us-west-1'      => 'dc2',
    'us-west-2'      => 'dc3',
    'eu-central-1'   => 'dc4',
    'eu-west-1'      => 'dc5',
    'ap-northeast-1' => 'dc6',
    'ap-southeast-1' => 'dc7',
    'ap-southeast-2' => 'dc8',
    'sa-east-1'      => 'dc9'
  },
  az: {
    'a' => 'rac1',
    'b' => 'rac2',
    'c' => 'rac3',
    'd' => 'rac4',
    'e' => 'rac5'
  }
}

nodes = search(
  :node,
  node['et_cassandra']['discovery']['topo_search_str'] +
  " AND chef_environment:#{node.chef_environment}",
  keys: {
    'ip'  => ['ipaddress'],
    'ec2' => ['placement_availability_zone']
  }
)

topology = Hash.new { |h, k| h[k] = {} }
nodes.each do |node|
  region = node['ec2']['placement_availability_zone'][0..-2]
  az     = node['ec2']['placement_availability_zone'][-1, 1]

  dc  = topology_analogs[:dc][region]
  rac = topology_analogs[:az][az]

  topology[dc][rac] = [
    node['ipaddress']
  ]
end

%w(
  properties
  yaml
).each do |ext|
  template "/etc/cassandra/cassandra-topology.#{ext}" do
    variables topology: topology
  end
end
