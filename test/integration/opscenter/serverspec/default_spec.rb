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

  it 'has a directory for its cluster configs' do
    expect(file('/etc/opscenter/clusters')).to be_directory
  end

  context 'has a cluster config' do
    describe file '/etc/opscenter/clusters/test_cluster.conf' do
      it { is_expected.to be_file }
      describe '#content' do
        subject { super().content }
        it { is_expected.to include '[jmx]' }
        it { is_expected.to include 'username = ' }
        it { is_expected.to include 'password = ' }
        it { is_expected.to include 'port = 7199' }
        it { is_expected.to include '[cassandra]' }
        it { is_expected.to include 'seed_hosts = 0.0.0.0' }
        it { is_expected.to include 'api_port = 9160' }
      end
    end
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

  context 'has the correct config' do
    describe file '/var/lib/datastax-agent/conf/address.yaml' do
      it { is_expected.to be_file }
      describe '#content' do
        subject { super().content }
        it { is_expected.to match(/stomp_interface: \b(?:\d{1,3}\.){3}\d{1,3}\b/i) }
        it { is_expected.to include 'use_ssl: 0' }
      end
    end
  end
end