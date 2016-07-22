#
# Cookbook Name:: et_cassandra
# Recipe:: logging
#
# Copyright (c) 2016 EverTrue, Inc., All Rights Reserved.

node.override['filebeat']['prospectors']['cassandra_system']['filebeat']['prospectors'] = {
  'paths' => ["#{node['et_cassandra']['log_dir']}/system.log"],
  'document_type' => 'cassandra_system'
}
