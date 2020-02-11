#
# Cookbook Name:: et_cassandra
# Recipe:: backups
#
# Copyright (c) 2014 EverTrue, Inc., All Rights Reserved.

include_recipe 'poise-python'
python_package 's3cmd'

include_recipe 'et_fog'

snapshot_conf = node['et_cassandra']['snapshot_conf'].to_h

if node['et_cassandra']['snapshot']['data_bag']
  creds = data_bag_item(
    node['et_cassandra']['snapshot']['data_bag'],
    node['et_cassandra']['snapshot']['data_bag_item']
  )['CassandraBackups']
  snapshot_conf['AWS_ACCESS_KEY_ID'] = creds['access_key_id']
  snapshot_conf['AWS_SECRET_ACCESS_KEY'] = creds['secret_access_key']
elsif node['et_cassandra']['aws_access_key_id']
  snapshot_conf['AWS_ACCESS_KEY_ID'] = node['et_cassandra']['aws_access_key_id']
  snapshot_conf['AWS_SECRET_ACCESS_KEY'] = node['et_cassandra']['aws_secret_access_key']
end

file '/etc/cassandra/snapshots.conf' do
  content snapshot_conf.map { |k, v| "#{k}=#{v}" }.join("\n") + "\n"
  mode    0600
end

template '/usr/local/sbin/snapshot-cassandra' do
  source 'snapshot-cassandra.erb'
  mode   0755
end

template '/usr/local/sbin/upload-incrementals' do
  source 'upload-incrementals.erb'
  mode   0755
end

template '/usr/local/sbin/upload-old-snapshots' do
  mode   0755
end

directory node['et_cassandra']['snapshot_conf']['TARBALL_DIR'] do
  recursive true
end

cron_d 'cassandra_weekly_snapshot' do
  path '/usr/local/bin:/usr/bin:/bin'
  command '/usr/local/sbin/snapshot-cassandra 2>&1 | logger -t snapshot-cassandra -p cron.info -s'
  minute  0
  hour    13
  weekday 6.to_s
end

cron_d 'cassandra_daily_incremental' do
  path '/usr/local/bin:/usr/bin:/bin'
  command '/usr/local/sbin/upload-incrementals 2>&1 | logger -t upload-incrementals -p cron.info -s'
  minute  0
  hour    1
end

%w(
  cassandra-daily-incremental
  cassandra-weekly-snapshot
).each do |job|
  cron_d job do
    action :delete
  end
end
