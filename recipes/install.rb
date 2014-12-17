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
