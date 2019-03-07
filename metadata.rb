name             'et_cassandra'
maintainer       'EverTrue, Inc.'
maintainer_email 'devops@evertrue.com'
license          'all_rights'
description      'Installs/Configures a Cassandra ring w/ various goodies'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '7.1.9'

supports 'ubuntu', '= 14.04'

chef_version '~> 12.10'

# Prevent new JDK's from being installed. Old ones do not get cleaned up and large amounts of
# disk space get used. Plus: C* is never restarted so security updates are mostly pointless.
depends 'java', '~> 1.48.0'

depends 'cron'
depends 'python'
depends 'et_fog'
