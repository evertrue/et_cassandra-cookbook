default['et_cassandra']['opscenter']['cluster']['name'] = nil
default['et_cassandra']['opscenter']['opscenterd_search_str'] = 'role:cassandra_opscenter'
default['et_cassandra']['opscenter']['user'] = 'opscenter-agent'

default['et_cassandra']['opscenter']['config'] = {
  'webserver' => {
    'port' => 8888,
    'interface' => '0.0.0.0'
  },
  'authentication' => {
    'enabled' => false
  },
  'agents' => {
    'use_ssl' => false
  }
}

default['et_cassandra']['opscenter']['cluster']['managed'] = false
default['et_cassandra']['opscenter']['config']['logging']['log_path'] =
  '/var/log/opscenter/opscenterd.log'
