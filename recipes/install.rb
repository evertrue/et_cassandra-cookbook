#
# Cookbook Name:: et_cassandra
# Recipe:: install
#
# Copyright (c) 2014 EverTrue, Inc., All Rights Reserved.

node['et_cassandra']['packages'].each do |_k, pkg|
  package pkg
end

user node['et_cassandra']['user'] do
  home node['et_cassandra']['home']
  system true
  shell  '/bin/sh'
  supports manage_home: true
end

include_recipe 'et_cassandra::repo'

package %w(cassandra dsc21) do
  options '-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"'
  version [node['et_cassandra']['version']['cassandra'],
           node['et_cassandra']['version']['dsc21']]
end

template "/etc/default/#{node['et_cassandra']['user']}" do
  source 'cassandra-user-default.erb'
  notifies :restart, 'service[cassandra]' unless node['et_cassandra']['skip_restart']
end

include_recipe 'storage'

node.set['et_cassandra']['log_dir'] =
  if node['storage']['ephemeral_mounts']
    "#{node['storage']['ephemeral_mounts'].first}/cassandra"
  else
    '/var/log/cassandra'
  end

[
  node['et_cassandra']['config']['data_file_directories'],
  node['et_cassandra']['config']['commitlog_directory'],
  node['et_cassandra']['config']['saved_caches_directory'],
  node['et_cassandra']['log_dir']
].flatten.each do |dir|
  directory dir do
    owner node['et_cassandra']['user']
    group node['et_cassandra']['user']
    recursive true
  end
end

service 'cassandra' do
  supports status: true, restart: true
  action node['et_cassandra']['service_action']
end

if node['et_cassandra']['mocking']
  seed_ips = [node['ipaddress']]
else
  seeds = search(
    :node,
    node['et_cassandra']['discovery']['seed_search_str'] +
    " AND chef_environment:#{node.chef_environment}",
    filter_result: {
      'ip' => %w(ipaddress)
    }
  )

  seed_ips = (
    if seeds.nil? || seeds.empty?
      log 'Assuming this node is the first node of a new ring, and should be a Cassandra seed'
      [node['ipaddress']]
    elsif Chef::VersionConstraint.new('< 12.1.1').include? Chef::VERSION
      # Versions of Chef prior to 12.1 return this data in a format that can only
      # be described as "bizarre."
      seeds.each_with_object([]) { |s, m| s['data'].map { |_k, ip| m << ip } }
    else
      seeds.map { |h| h['ip'] }
    end
  )

  # Make sure our own IP is in the list
  seed_ips |= [node['ipaddress']] if node.roles.include?('cassandra_seed')
end

# Structure is seemingly ornate to map 1:1 to YAML output needed in actual config
node.default['et_cassandra']['config']['seed_provider'] = [
  {
    'class_name' => 'org.apache.cassandra.locator.SimpleSeedProvider',
    'parameters' => [
      {
        'seeds' => seed_ips.join(',')
      }
    ]
  }
]

[
  'cassandra-env.sh',
  'cassandra.yaml',
  'logback.xml'
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

template '/usr/sbin/cassandra' do
  source 'cassandra-bin.erb'
  mode 0755
end
