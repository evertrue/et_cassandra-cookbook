#
# Cookbook Name:: et_cassandra
# Recipe:: opscenter
#
# Copyright (c) 2014 EverTrue, Inc., All Rights Reserved.

include_recipe 'et_cassandra::repo'

package 'datastax-agent' do
  version node['et_cassandra']['datastax']['version']
  notifies :restart, 'service[datastax-agent]'
end

service 'datastax-agent' do
  supports status: true, restart: true
  action [:enable, :start]
end

package 'opscenter' do
  version node['et_cassandra']['datastax']['version']
  notifies :restart, 'service[opscenterd]'
  only_if { node['et_cassandra']['opscenter']['master'] }
end

service 'opscenterd' do
  supports status: true, restart: true
  action [:enable, :start]
  only_if { node['et_cassandra']['opscenter']['master'] }
end

node.default['et_cassandra']['opscenter']['cluster']['name'] =
  node['et_cassandra']['config']['cluster_name'].downcase.tr(' ', '_')

template '/etc/opscenter/opscenterd.conf' do
  source 'opscenter.conf.erb'
  notifies :restart, 'service[opscenterd]'
  variables(
    config: node['et_cassandra']['opscenter']['config']
  )
  only_if { node['et_cassandra']['opscenter']['master'] }
end

directory '/etc/opscenter/clusters' do
  only_if do
    node['et_cassandra']['opscenter']['master'] &&
      node['et_cassandra']['opscenter']['cluster']['managed']
  end
end

template "/etc/opscenter/clusters/#{node['et_cassandra']['opscenter']['cluster']['name']}.conf" do
  source 'opscenter.conf.erb'
  variables(
    config: node['et_cassandra']['opscenter']['cluster']['config']
  )
  notifies :restart, 'service[opscenterd]'
  only_if do
    node['et_cassandra']['opscenter']['master'] &&
      node['et_cassandra']['opscenter']['cluster']['managed']
  end
end

directory '/var/log/opscenter' do
  mode '0755'
  only_if { node['et_cassandra']['opscenter']['master'] }
end

agent_conf_path = '/var/lib/datastax-agent/conf'

execute "rm -rf #{agent_conf_path}" do
  notifies :create, "link[#{agent_conf_path}]", :immediately
  not_if { ::File.symlink? agent_conf_path }
end

link '/var/lib/datastax-agent/conf' do
  to '/etc/datastax-agent'
  action :nothing
end

if node['et_cassandra']['opscenter']['master']
  stomp_interface = node['ipaddress']
else
  r = search(
    :node,
    node['et_cassandra']['opscenter']['opscenterd_search_str'] +
    " AND chef_environment:#{node.chef_environment}",
    filter_result: {
      'ip' => %w(ipaddress)
    }
  ).first

  raise 'Could not find any OpsCenter nodes' unless r

  stomp_interface = (
    if Chef::VersionConstraint.new('< 12.1.1').include?(Chef::VERSION)
      r['data']['ip']
    else
      r['ip']
    end
  )
end

use_ssl = (node['et_cassandra']['opscenter']['config']['agents']['use_ssl'] ? 1 : 0)

template "#{agent_conf_path}/address.yaml" do
  notifies :restart, 'service[datastax-agent]'
  variables(
    stomp_interface: stomp_interface,
    use_ssl: use_ssl
  )
end

template '/etc/default/datastax-agent' do
  source 'datastax-agent-default.erb'
  notifies :restart, 'service[datastax-agent]'
end

cookbook_file '/etc/init.d/datastax-agent' do
  source   'datastax-agent-init'
  mode     0755
  notifies :restart, 'service[datastax-agent]'
end

template "#{agent_conf_path}/log4j.properties" do
  source 'datastax-log4j.properties.erb'
  notifies :restart, 'service[datastax-agent]'
end

directory node['et_cassandra']['datastax-agent']['log_dir'] do
  owner     node['et_cassandra']['user']
  group     node['et_cassandra']['user']
  recursive true
  only_if   { node['et_cassandra']['datastax-agent']['log_dir'] != '/var/log/datastax-agent' }
end
