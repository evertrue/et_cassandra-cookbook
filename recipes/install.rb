#
# Cookbook Name:: et_cassandra
# Recipe:: install
#
# Copyright (c) 2014 EverTrue, Inc., All Rights Reserved.

package node['et_cassandra']['jnapkg']

user node['et_cassandra']['user'] do
  system true
  shell  '/bin/sh'
end

apt_repository 'cassandra' do
  uri 'http://debian.datastax.com/community'
  components %w(stable main)
  key 'http://debian.datastax.com/debian/repo_key'
end

package 'cassandra' do
  version node['et_cassandra']['version']
  action :install
end

service 'cassandra' do
  supports status: true, restart: true
  action [:enable, :start]
end

seeds = search(
  :node,
  node['et_cassandra']['discovery']['seed_search_str'] +
  " AND chef_environment:#{node.chef_environment}",
  keys: {
    'ip'  => ['ipaddress']
  }
)

seed_ips = ''
seeds.each do |s|
  seed_ips + "#{s['ip']},"
end

# Structure is seemingly ornate to map 1:1 to YAML output needed in actual config
node.default['et_cassandra']['config']['seed_provider'] = [
  {
    'class_name' => 'org.apache.cassandra.locator.SimpleSeedProvider',
    'parameters' => [
      {
        'seeds' => seed_ips
      }
    ]
  }
]

[
  'cassandra-env.sh',
  'cassandra.yaml'
].each do |conf|
  template "#{node['et_cassandra']['conf_path']}/#{conf}" do
    notifies :restart, 'service[cassandra]' unless node['et_cassandra']['skip_restart']
  end
end

include_recipe 'et_cassandra::search_discovery'
