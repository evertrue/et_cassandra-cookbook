#
# Cookbook Name:: et_cassandra
# Recipe:: install
#
# Copyright (c) 2014 EverTrue, Inc., All Rights Reserved.

package node['et_cassandra']['jnapkg']

user node['et_cassandra']['user'] do
  home node['et_cassandra']['home']
  system true
  shell  '/bin/sh'
  supports manage_home: true
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

[
  node['et_cassandra']['config']['data_file_directories'],
  node['et_cassandra']['config']['commitlog_directory'],
  node['et_cassandra']['config']['saved_caches_directory']
].flatten.each do |dir|
  directory dir do
    owner node['et_cassandra']['user']
    group node['et_cassandra']['user']
    recursive true
  end
end

service 'cassandra' do
  supports status: true, restart: true
  action [:enable, :start]
end

seeds = search(
  :node,
  node['et_cassandra']['discovery']['seed_search_str'] +
  " AND chef_environment:#{node.chef_environment}",
  filter_result: {
    'ip' => %w(ipaddress)
  }
)

seed_ips = seeds.each_with_object([]) { |s, m| s['data'].map { |_k, ip| m << ip } }.join ','

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

# Ensure Cassandra is not restarted on subsequent runs
ruby_block 'cassandra_started' do
  block do
    node.set['et_cassandra']['skip_restart'] = true
    node.set['et_cassandra']['service_action'] = :enable
    node.save
  end
end
