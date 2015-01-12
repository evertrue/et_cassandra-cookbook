#
# Cookbook Name:: et_cassandra
# Recipe:: opscenter
#
# Copyright (c) 2014 EverTrue, Inc., All Rights Reserved.

include_recipe 'et_cassandra::repo'

package 'datastax-agent'
service 'datastax-agent' do
  supports status: true, restart: true
  action [:enable, :start]
end

package 'opscenter' do
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
