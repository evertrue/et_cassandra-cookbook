snapshot_conf = node['et_cassandra']['snapshot_conf'].to_h

creds = data_bag_item(
  node['et_cassandra']['snapshot']['data_bag'],
  node['et_cassandra']['snapshot']['data_bag_item']
)['CassandraBackups']
snapshot_conf['AWS_ACCESS_KEY_ID'] = creds['access_key_id']
snapshot_conf['AWS_SECRET_ACCESS_KEY'] = creds['secret_access_key']

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
