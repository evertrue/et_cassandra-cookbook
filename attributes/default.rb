default['et_cassandra']['version'] = '2.1.0-2'

# JVM Stack size - default of 180k is not enough and prevents Cassandra from running
default['et_cassandra']['stacksize'] = 'Xss228k'

default['et_cassandra']['user'] = 'cassandra'

# As per DatStax docs re: the JNA improving memory usage
# http://www.datastax.com/documentation/cassandra/1.2/cassandra/install/installJnaDeb.html
default['et_cassandra']['jnapkg'] = 'libjna-java'

# We don't necessarily want all of the nodes in the cluster to restart
# upon configuration changes
default['et_cassandra']['skip_restart'] = true

default['et_cassandra']['env']['max_heap_size'] = '6G'
default['et_cassandra']['env']['heap_newsize'] = '1600M'
default['et_cassandra']['env']['heapdump_dir'] = '/var/lib/cassandra/heap_dumps'
default['et_cassandra']['env']['malloc_arena_max'] = 16
default['et_cassandra']['env']['enable_gc_logging'] = true

# Node discovery
default['et_cassandra']['discovery']['search_str'] = 'recipe:et_cassandra'

# Java install settings
default['java']['install_flavor'] = 'openjdk'
default['java']['jdk_version'] = '7'
