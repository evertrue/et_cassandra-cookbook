cookbook_file '/usr/local/bin/cassandra-repair' do
  mode 0755
end

cron_d 'cassandra_daily_repair' do
  command '/usr/local/bin/cassandra-repair'
  minute  20
  hour    4
  # Deleting this until we can figure out why jobs don't space properly
  action :delete
end
