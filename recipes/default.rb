#
# Cookbook Name:: et_cassandra
# Recipe:: default
#
# Copyright (c) 2014 EverTrue, Inc., All Rights Reserved.

include_recipe 'apt'
include_recipe 'java'
include_recipe 'et_cassandra::install'
