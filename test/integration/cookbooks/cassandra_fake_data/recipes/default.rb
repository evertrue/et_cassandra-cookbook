execute 'write_900k_rows' do
  command 'cassandra-stress write n=900000 no-warmup'
  creates '/var/lib/cassandra/data/keyspace1'
  # Cassandra sometimes takes a few seconds to start up
  retries 4
  retry_delay 5
  action  :run
end
