#
# Cookbook Name:: et_cassandra
# Recipe:: default
#
# Copyright (c) 2014 EverTrue, Inc., All Rights Reserved.

if Chef::VersionConstraint.new('< 12.10.0').include? Chef::VERSION
  raise 'This recipe requires chef-client version 12.10.0 or higher'
end

apt_update 'et_cassandra' do
  action :nothing
end.run_action :periodic

include_recipe 'java'
include_recipe 'et_cassandra::install'
include_recipe 'et_cassandra::repair_jobs'
