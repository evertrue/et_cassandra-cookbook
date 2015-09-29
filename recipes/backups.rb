include_recipe 'python'
python_pip 'boto'

include_recipe 'et_fog'

snapshot_conf = node['et_cassandra']['snapshot_conf'].to_h

creds = data_bag_item(
  node['et_cassandra']['snapshot']['data_bag'],
  node['et_cassandra']['snapshot']['data_bag_item']
)['CassandraBackups']
snapshot_conf['AWS_ACCESS_KEY_ID'] =
  node['et_cassandra']['aws_access_key_id'] || creds['access_key_id']
snapshot_conf['AWS_SECRET_ACCESS_KEY'] =
  node['et_cassandra']['aws_secret_access_key'] || creds['secret_access_key']

unless node['et_cassandra']['mocking']
  et_cassandra_backup_lifecycle "cassandra snapshots expiration (#{node.chef_environment})" do
    aws_access_key_id     snapshot_conf['AWS_ACCESS_KEY_ID']
    aws_secret_access_key snapshot_conf['AWS_SECRET_ACCESS_KEY']
    type                  'snapshots'
    days                  node['et_cassandra']['snapshot']['snapshot_retention_days']
    bucket                node['et_cassandra']['snapshot_conf']['BUCKET']
    region                node['et_cassandra']['snapshot_conf']['REGION']
  end

  et_cassandra_backup_lifecycle "cassandra incrementals expiration (#{node.chef_environment})" do
    aws_access_key_id     snapshot_conf['AWS_ACCESS_KEY_ID']
    aws_secret_access_key snapshot_conf['AWS_SECRET_ACCESS_KEY']
    type                  'incrementals'
    days                  node['et_cassandra']['snapshot']['incremental_retention_days']
    bucket                node['et_cassandra']['snapshot_conf']['BUCKET']
    region                node['et_cassandra']['snapshot_conf']['REGION']
  end
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

cron_d 'cassandra_weekly_snapshot' do
  command '/usr/local/sbin/snapshot-cassandra | logger -t snapshot-cassandra -p cron.info'
  minute  0
  hour    1
  weekday 0
end

cron_d 'cassandra_daily_incremental' do
  command '/usr/local/sbin/upload-incrementals | logger -t upload-incrementals -p cron.info'
  minute  0
  hour    1
  weekday '1-6'
end

%w(
  cassandra-daily-incremental
  cassandra-weekly-snapshot
).each do |job|
  cron_d job do
    action :delete
  end
end
