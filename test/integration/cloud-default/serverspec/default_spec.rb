require 'spec_helper'

describe 'et_cassandra::default' do
  it_behaves_like 'a default installation', '/mnt', '/mnt/dev0'
end
