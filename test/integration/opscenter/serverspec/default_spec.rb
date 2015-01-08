require 'spec_helper'

describe 'DataStax OpsCenter' do
  it 'has DataStax OpsCenter installed' do
    expect(package('opscenter')).to be_installed
  end

  it 'has enabled the OpsCenter service' do
    expect(service('opscenterd')).to be_enabled
  end

  it 'has a running server for OpsCenter' do
    expect(service('opscenterd')).to be_running
  end

  it 'has the DataStax Agent installed' do
    expect(package('datastax-agent')).to be_installed
  end

  it 'has enabled the DataStax Agent service' do
    expect(service('datastax-agent')).to be_enabled
  end

  it 'has a running service for the DataStax Agent' do
    expect(service('datastax-agent')).to be_running
  end
end
