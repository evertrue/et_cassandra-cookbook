default['et_cassandra']['version'] = '2.1.0-2'

default['et_cassandra']['user'] = 'cassandra'
default['et_cassandra']['home'] = '/var/lib/cassandra'

# Path to Cassandra configs
default['et_cassandra']['conf_path'] = '/etc/cassandra'

# As per DatStax docs re: the JNA improving memory usage
# http://www.datastax.com/documentation/cassandra/1.2/cassandra/install/installJnaDeb.html
default['et_cassandra']['jnapkg'] = 'libjna-java'

# We don't necessarily want all of the nodes in the cluster to restart
# upon configuration changes
default['et_cassandra']['skip_restart'] = false
default['et_cassandra']['service_action'] = [:enable, :start]

default['et_cassandra']['env']['max_heap_size'] = '6G'
default['et_cassandra']['env']['heap_newsize'] = '1600M'
default['et_cassandra']['env']['heapdump_dir'] = '/var/lib/cassandra/heap_dumps'
default['et_cassandra']['env']['malloc_arena_max'] = 16
default['et_cassandra']['env']['enable_gc_logging'] = true

# Node discovery
default['et_cassandra']['discovery']['topo_search_str'] = 'recipe:et_cassandra'
default['et_cassandra']['discovery']['seed_search_str'] = 'roles:cassandra_seed'

# Cassandra storage config
# Values reflect the default configuration shipped w/ the Cassandra version
# specified above
# See http://wiki.apache.org/cassandra/StorageConfiguration for docs
default['et_cassandra']['config'] = {
  'cluster_name'                   => 'Test Cluster',
  'num_tokens'                     => 256,
  'hinted_handoff_enabled'         => true,
  'max_hint_window_in_ms'          => 10_800_000,
  'hinted_handoff_throttle_in_kb'  => 1024,
  'max_hints_delivery_threads'     => 2,
  'batchlog_replay_throttle_in_kb' => 1024,
  'authenticator'                  => 'AllowAllAuthenticator',
  'authorizer'                     => 'AllowAllAuthorizer',
  'permissions_validity_in_ms'     => 2000,
  'partitioner'                    => 'org.apache.cassandra.dht.Murmur3Partitioner',
  'data_file_directories'          => ["#{node['et_cassandra']['home']}/cassandra/data"],
  'commitlog_directory'            => "#{node['et_cassandra']['home']}/cassandra/commitlog",
  'disk_failure_policy'            => 'stop',
  'commit_failure_policy'          => 'stop',
  'key_cache_size_in_mb'           => nil,
  'key_cache_save_period'          => 14_400,
  'row_cache_size_in_mb'           => 0,
  'row_cache_save_period'          => 0,
  'counter_cache_size_in_mb'       => nil,
  'counter_cache_save_period'      => 7200,
  'saved_caches_directory'         => "#{node['et_cassandra']['home']}/cassandra/saved_caches",
  'commitlog_sync'                 => 'periodic',
  'commitlog_sync_period_in_ms'    => 10_000,
  'commitlog_segment_size_in_mb'   => 32,
  'concurrent_reads'                         => 32,
  'concurrent_writes'                        => 32,
  'concurrent_counter_writes'                => 32,
  'memtable_allocation_type'                 => 'heap_buffers',
  'index_summary_capacity_in_mb'             => nil,
  'index_summary_resize_interval_in_minutes' => 60,
  'trickle_fsync'                            => false,
  'trickle_fsync_interval_in_kb'             => 10_240,
  'storage_port'                             => 7000,
  'ssl_storage_port'                         => 7001,
  'listen_address'                           => 'localhost',
  'start_native_transport'                   => true,
  'native_transport_port'                    => 9042,
  'start_rpc'                                => true,
  'rpc_address'                              => 'localhost',
  'rpc_port'                                 => 9160,
  'rpc_keepalive'                            => true,
  'rpc_server_type'                          => 'sync',
  'thrift_framed_transport_size_in_mb'       => 15,
  'incremental_backups'                      => false,
  'snapshot_before_compaction'               => false,
  'auto_snapshot'                            => true,
  'tombstone_warn_threshold'                 => 1000,
  'tombstone_failure_threshold'              => 100_000,
  'column_index_size_in_kb'                  => 64,
  'batch_size_warn_threshold_in_kb'          => 5,
  'compaction_throughput_mb_per_sec'         => 16,
  'sstable_preemptive_open_interval_in_mb'   => 50,
  'read_request_timeout_in_ms'               => 5000,
  'range_request_timeout_in_ms'              => 10_000,
  'write_request_timeout_in_ms'              => 2000,
  'counter_write_request_timeout_in_ms'      => 5000,
  'cas_contention_timeout_in_ms'             => 1000,
  'truncate_request_timeout_in_ms'           => 60_000,
  'request_timeout_in_ms'                    => 10_000,
  'cross_node_timeout'                       => false,
  'endpoint_snitch'                          => 'SimpleSnitch',
  'dynamic_snitch_update_interval_in_ms'     => 100,
  'dynamic_snitch_reset_interval_in_ms'      => 600_000,
  'dynamic_snitch_badness_threshold'         => 0.1,
  'request_scheduler'                        => 'org.apache.cassandra.scheduler.NoScheduler',
  'server_encryption_options' => {
    'internode_encryption' => 'none',
    'keystore'             => 'conf/.keystore',
    'keystore_password'    => 'cassandra',
    'truststore'           => 'conf/.truststore',
    'truststore_password'  => 'cassandra'
  },
  'client_encryption_options' => {
    'enabled'           => false,
    'keystore'          => 'conf/.keystore',
    'keystore_password' => 'cassandra'
  },
  'internode_compression' => 'all',
  'inter_dc_tcp_nodelay'  => false
}

# Java install settings
default['java']['install_flavor'] = 'oracle'
default['java']['jdk_version'] = '7'
default['java']['oracle']['accept_oracle_download_terms'] = true
