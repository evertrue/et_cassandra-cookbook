require 'spec_helper'

describe 'et_cassandra::opscenter' do
  it_behaves_like 'an opscenter installation', '/mnt', '/mnt/dev0'
end
