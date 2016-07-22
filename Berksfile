source :chef_server
source 'https://supermarket.chef.io'

metadata

group :integration do
  cookbook 'et_logger'
  cookbook 'ec2test', path: 'test/integration/cookbooks/ec2test'
  cookbook 'cassandra_fake_data', path: 'test/integration/cookbooks/cassandra_fake_data'
end
