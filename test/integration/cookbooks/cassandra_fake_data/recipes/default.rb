[
  "#{Chef::Config[:file_cache_path]}/build_big_data",
  "#{Chef::Config[:file_cache_path]}/fakedata.cql"
].each do |cb_file|
  cookbook_file cb_file do
    mode 0755
  end
end

execute 'create_bogus_keyspace' do
  command "/usr/bin/cqlsh -f #{Chef::Config[:file_cache_path]}/fakedata.cql"
  creates '/var/lib/cassandra/data/fakedata'
  action  :run
end

execute 'fill_bogus_keyspace' do
  command "#{Chef::Config[:file_cache_path]}/build_big_data 100000 > " \
          '/tmp/loadfakedata.cql && cqlsh -f /tmp/loadfakedata.cql'
  creates '/tmp/loadfakedata.cql'
  action  :run
end
