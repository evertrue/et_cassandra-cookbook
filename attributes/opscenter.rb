default['et_cassandra']['opscenter']['cluster']['name'] = nil

default['et_cassandra']['opscenter']['config'] = {
  'webserver' => {
    'port' => 8888,
    'interface' => '0.0.0.0'
  },
  'authentication' => {
    'enabled' => false
  }
}

default['et_cassandra']['opscenter']['cluster']['managed'] = false
