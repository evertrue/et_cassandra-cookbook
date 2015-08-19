require 'spec_helper'

describe 'Apache Cassandra' do
  context 'has the necessary packages installed' do
    %w(
      libjna-java
      libjemalloc1
    ).each do |pkg|
      describe package pkg do
        it { is_expected.to be_installed }
      end
    end

    describe package('cassandra') do
      it { is_expected.to be_installed.with_version('2.1.8') }
    end

    describe package('dsc21') do
      it { is_expected.to be_installed.with_version('2.1.8-1') }
    end
  end

  context 'user has a high file descriptor limit' do
    describe file '/etc/default/cassandra' do
      it { is_expected.to be_file }
      describe '#content' do
        subject { super().content }
        it { is_expected.to include 'ulimit -n 65535' }
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
        it { is_expected.to include 'export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/lib/' }
        it { is_expected.to include 'JVM_OPTS="$JVM_OPTS -Djava.library.path=/usr/lib/x86_64-linux-gnu/lib/"' }
        it { is_expected.to include 'JVM_OPTS="$JVM_OPTS -XX:+CMSConcurrentMTEnabled' }
        it { is_expected.to include 'JVM_OPTS="$JVM_OPTS -XX:ConcGCThreads=6' }
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
        it { is_expected.to include 'endpoint_snitch: GossipingPropertyFileSnitch' }
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
        it { is_expected.to include '169.254.0.1=us-east-1:b' }
        it { is_expected.to include '169.254.0.2=us-east-1:b' }
        it { is_expected.to include '169.254.0.3=us-east-1:c' }
        it { is_expected.to include '169.254.0.4=us-east-1:c' }
        it { is_expected.to include '169.254.0.5=us-east-1:d' }
      end
    end

    # Content assertion is split in two b/c we do not have a reliable way
    # to definitively know the test node's IP address
    describe file '/etc/cassandra/cassandra-topology.yaml' do
      it { is_expected.to be_file }
      describe '#content' do
        subject { super().content }
        it do
          is_expected.to include <<-eos
topology:
  - dc_name: us-east-1
    racks:
      - rack_name: b
        nodes:
          - broadcast_address: 169.254.0.1
          - broadcast_address: 169.254.0.2
eos
        end

        it do
          is_expected.to include <<-eos
      - rack_name: c
        nodes:
          - broadcast_address: 169.254.0.3
          - broadcast_address: 169.254.0.4
      - rack_name: d
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
        it { is_expected.to include 'dc=us-east-1' }
        it { is_expected.to include 'rack=b' }
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
    expect(package('datastax-agent')).to be_installed.with_version('5.2.0')
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

    describe file '/etc/default/datastax-agent' do
      it { is_expected.to be_file }
      describe '#content' do
        subject { super().content }
        it { is_expected.to include 'LOG="/var' }
      end
    end
  end

  context 'has a single place for config' do
    describe file '/var/lib/datastax-agent/conf' do
      it { is_expected.to be_symlink }
      it { is_expected.to be_linked_to '/etc/datastax-agent' }
    end
  end
end

describe 'Snapshot Tool' do
  context 'is installed' do
    describe file '/usr/local/sbin/snapshot-cassandra' do
      it { is_expected.to be_file }
      it { is_expected.to be_mode(755) }
    end
  end

  context 'has correct configuration' do
    describe file '/etc/cassandra/snapshots.conf' do
      it { is_expected.to be_file }
      it { is_expected.to be_mode(600) }
      describe '#content' do
        subject { super().content }
        it { is_expected.to include 'BUCKET=cassandra_bucket' }
        it { is_expected.to include 'AWS_ACCESS_KEY_ID' }
        it { is_expected.to include 'AWS_SECRET_ACCESS_KEY' }
      end
    end
  end
end
