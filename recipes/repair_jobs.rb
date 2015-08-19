cookbook_file '/usr/local/bin/cassandra-repair' do
  mode 0755
end

cron_d 'cassandra_repair' do
  command '/usr/local/bin/cassandra-repair | logger -t cassandra-repair -p cron.info'
  minute  20
  hour    4
  day     %w(
    us-east-1a
    us-east-1b
    us-east-1c
    us-east-1d
  ).find_index(node['ec2']['placement_availability_zone'])
end

cron_d 'cassandra_daily_repair' do
  action :delete
end
