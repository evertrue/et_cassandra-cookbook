default['et_cassandra']['snapshot_conf']['BUCKET'] = 'cassandra_bucket'
default['et_cassandra']['snapshot_conf']['CHEF_ENVIRONMENT'] = node.chef_environment
default['et_cassandra']['snapshot_conf']['REGION'] = 'us-east-1'
default['et_cassandra']['snapshot_conf']['SKIP_KEYSPACES'] =
  '(keyspace1 system_traces OpsCenter)'
default['et_cassandra']['snapshot_conf']['TARBALL_DIR'] = '/var/lib/cassandra/tarball_dir'
default['et_cassandra']['snapshot']['data_bag'] = 'secrets'
default['et_cassandra']['snapshot']['data_bag_item'] = 'aws_credentials'
default['et_cassandra']['snapshot']['wait_secs'] = 30
default['et_cassandra']['snapshot']['tar_retries'] = 5
default['et_cassandra']['snapshot']['upload_retries'] = 5
default['et_cassandra']['snapshot']['tar_retry_secs'] = 30
default['et_cassandra']['snapshot']['upload_retry_delay'] = 5
default['et_cassandra']['incrementals']['upload_retry_delay'] = 5
default['et_cassandra']['incrementals']['upload_retries'] = 5
