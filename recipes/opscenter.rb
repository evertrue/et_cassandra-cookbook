#
# Cookbook Name:: et_cassandra
# Recipe:: opscenter
#
# Copyright (c) 2014 EverTrue, Inc., All Rights Reserved.

include_recipe 'et_cassandra::repo'

pkgs = %w(
  datastax-agent
)

svcs = %w(
  datastax-agent
)

if node['et_cassandra']['opscenter']['master']
  pkgs << 'opscenter'
  svcs << 'opscenterd'
end

pkgs.each do |pkg|
  package pkg
end

svcs.each do |svc|
  service svc do
    supports status: true, restart: true, reload: true
    action [:enable, :start]
  end
end

node.default['et_cassandra']['opscenter']['cluster']['name'] =
  node['et_cassandra']['config']['cluster_name'].downcase.tr(' ', '_')

template '/etc/opscenter/opscenterd.conf' do
  source 'opscenter.conf.erb'
  variables(
    config: node['et_cassandra']['opscenter']['config']
  )
end
