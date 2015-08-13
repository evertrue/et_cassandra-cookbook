cookbook_file '/usr/local/bin/cassandra-repair' do
  mode 0755
end

cron_d 'cassandra_daily_repair' do
  command '/usr/local/bin/cassandra-repair | logger -t cassandra-repair -p cron.info'
  minute  20
  hour    4
end
