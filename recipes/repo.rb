#
# Cookbook Name:: et_cassandra
# Recipe:: repo
#
# Copyright (c) 2014 EverTrue, Inc., All Rights Reserved.

apt_repository 'cassandra' do
  uri 'http://debian.datastax.com/community'
  distribution nil
  components %w(stable main)
  key 'http://debian.datastax.com/debian/repo_key'
end
