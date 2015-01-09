require 'spec_helper'

describe 'DataStax OpsCenter' do
  it 'is installed' do
    expect(package('opscenter')).to be_installed
  end

  it 'is enabled as a service' do
    expect(service('opscenterd')).to be_enabled
  end

  it 'is running as a service' do
    expect(service('opscenterd')).to be_running
  end
end

describe 'DataStax Agent' do
  it 'is installed' do
    expect(package('datastax-agent')).to be_installed
  end

  it 'is enabled as a service' do
    expect(service('datastax-agent')).to be_enabled
  end

  it 'is running as a service' do
    expect(service('datastax-agent')).to be_running
  end
end
