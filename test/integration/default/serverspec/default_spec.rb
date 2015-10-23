require 'spec_helper'

describe 'et_cassandra::default' do
  it_behaves_like 'a default installation', '/var', '/var/log'
end
