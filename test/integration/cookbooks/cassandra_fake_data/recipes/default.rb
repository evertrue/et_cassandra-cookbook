cookbook_file "#{Chef::Config[:file_cache_path]}/build_big_data" do
  mode 0755
end

execute 'create_bogus_keyspace' do
  command "/usr/bin/cqlsh -f #{Chef::Config[:file_cache_path]}/fakedata.cql"
  creates '/var/lib/cassandra/data/fakedata'
  action  :run
end

execute 'fill_bogus_keyspace' do
  command "#{Chef::Config[:file_cache_path]}/build_big_data 100000 > " \
          '/tmp/fakedata.cql && cqlsh -f /tmp/fakedata.cql'
  creates '/tmp/fakedata.cql'
  action  :run
end
