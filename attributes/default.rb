default['et_cassandra']['version'] = '2.1.0-2'

# JVM Stack size - default of 180k is not enough and prevents Cassandra from running
default['et_cassandra']['stacksize'] = 'Xss228k'

default['et_cassandra']['user'] = 'cassandra'

# As per DatStax docs re: the JNA improving memory usage
# http://www.datastax.com/documentation/cassandra/1.2/cassandra/install/installJnaDeb.html
default['et_cassandra']['jnapkg'] = 'libjna-java'

# Java install settings
default['java']['install_flavor'] = 'openjdk'
default['java']['jdk_version'] = '7'
