name             'et_cassandra'
maintainer       'EverTrue, Inc.'
maintainer_email 'devops@evertrue.com'
license          'all_rights'
description      'Installs/Configures a Cassandra ring w/ various goodies'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '7.0.1'

supports 'ubuntu', '= 14.04'

chef_version '~> 12.10'

depends 'java', '~> 1.29'
depends 'cron'
depends 'python'
depends 'et_fog'
