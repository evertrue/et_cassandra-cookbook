require 'spec_helper'

describe 'Apache Cassandra' do
  context 'has the necessary packages installed' do
    %w(
      libjna-java
      libjemalloc1
      cassandra
    ).each do |pkg|
      describe package pkg do
        it { is_expected.to be_installed }
      end
    end
  end

  it 'has an enabled service of cassandra' do
    expect(service('cassandra')).to be_enabled
  end

  it 'has a running service of cassandra' do
    expect(service('cassandra')).to be_running
  end

  it 'has the necessary permissions for its directories' do
    expect(file('/var/lib/cassandra/data')).to be_owned_by 'cassandra'
    expect(file('/var/lib/cassandra/commitlog')).to be_owned_by 'cassandra'
    expect(file('/var/lib/cassandra/saved_caches')).to be_owned_by 'cassandra'
  end

  context 'has the desired environment config' do
    describe file '/etc/cassandra/cassandra-env.sh' do
      it { is_expected.to be_file }
      describe '#content' do
        subject { super().content }
        it { is_expected.to include '#MAX_HEAP_SIZE="4G' }
        it { is_expected.to include '#HEAP_NEWSIZE="800M' }
        it { is_expected.to include '#export MALLOC_ARENA_MAX=4' }
        it { is_expected.to include "then\n    export MALLOC_ARENA_MAX=4" }
      end
    end
  end

  context 'has the desired configuration' do
    describe file '/etc/cassandra/cassandra.yaml' do
      it { is_expected.to be_file }
      describe '#content' do
        subject { super().content }
        it { is_expected.to include 'cluster_name: Test Cluster' }
        it { is_expected.to include 'cross_node_timeout: false' }
        it { is_expected.to include 'endpoint_snitch: SimpleSnitch' }
        it { is_expected.to include "data_file_directories:\n- \"/var/lib/cassandra/data\"" }
        it { is_expected.to include 'commitlog_directory: "/var/lib/cassandra/commitlog"' }
        it { is_expected.to include 'saved_caches_directory: "/var/lib/cassandra/saved_caches"' }
        it { is_expected.to include '- seeds: 169.254.0.1,169.254.0.3' }
      end
    end
  end

  context 'has the desired topology configured' do
    describe file '/etc/cassandra/cassandra-topology.properties' do
      it { is_expected.to be_file }
      describe '#content' do
        subject { super().content }
        it { is_expected.to include '169.254.0.2=DC1:RAC2' }
        it { is_expected.to include '169.254.0.4=DC1:RAC3' }
        it { is_expected.to include '169.254.0.5=DC1:RAC4' }
      end
    end

    describe file '/etc/cassandra/cassandra-topology.yaml' do
      it { is_expected.to be_file }
      describe '#content' do
        subject { super().content }
        it do
          is_expected.to include <<-eos
topology:
  - dc_name: DC1
    racks:
      - rack_name: RAC2
        nodes:
          - broadcast_address: 169.254.0.2
eos
        end

        it do
          is_expected.to include <<-eos
      - rack_name: RAC3
        nodes:
          - broadcast_address: 169.254.0.4
      - rack_name: RAC4
        nodes:
          - broadcast_address: 169.254.0.5
eos
        end
      end
    end

    describe file '/etc/cassandra/cassandra-rackdc.properties' do
      it { is_expected.to be_file }
      describe '#content' do
        subject { super().content }
        it { is_expected.to include 'dc=DC1' }
        it { is_expected.to include 'rack=RAC2' }
      end
    end
  end
end

describe 'DataStax OpsCenter' do
  it 'is not installed' do
    expect(package('opscenter')).to_not be_installed
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
