#
# Cookbook Name:: et_cassandra
# Recipe:: default
#
# Copyright (c) 2014 EverTrue, Inc., All Rights Reserved.

if Chef::VersionConstraint.new('< 12.0.0').include? Chef::VERSION
  fail 'This recipe requires chef-client version 12.0.0 or higher'
end

include_recipe 'apt'
include_recipe 'java'
include_recipe 'et_cassandra::install'
include_recipe 'et_cassandra::repair_jobs'
