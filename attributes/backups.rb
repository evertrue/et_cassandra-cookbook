default['et_cassandra']['snapshot_conf']['BUCKET'] = 'cassandra_bucket'
default['et_cassandra']['snapshot_conf']['CHEF_ENVIRONMENT'] = node.chef_environment
default['et_cassandra']['snapshot_conf']['REGION'] = 'us-east-1'
default['et_cassandra']['snapshot']['data_bag'] = 'secrets'
default['et_cassandra']['snapshot']['data_bag_item'] = 'aws_credentials'
default['et_cassandra']['snapshot']['snapshot_retention_days'] = 90
default['et_cassandra']['snapshot']['incremental_retention_days'] = 30
