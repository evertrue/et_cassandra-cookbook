name             'et_cassandra'
maintainer       'EverTrue, Inc.'
maintainer_email 'devops@evertrue.com'
license          'all_rights'
description      'Installs/Configures a Cassandra ring w/ various goodies'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

supports 'ubuntu', '= 14.04'

depends 'java', '~> 1.29'
depends 'apt',  '~> 2.6'
