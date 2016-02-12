shared_examples_for 'a default installation' do |log_root, log_dir|
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
        it { is_expected.to be_installed.with_version('2.1.12') }
      end

      describe package('dsc21') do
        it { is_expected.to be_installed.with_version('2.1.12-1') }
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
          it { is_expected.to match(/\- seeds: (?:[0-9]{1,3}\.){3}[0-9]{1,3}/) }
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

    context 'has content in the correct log files' do
      describe file("#{log_dir}/cassandra/system.log") do
        it { is_expected.to be_file }
        describe '#content' do
          subject { super().content }
          it { is_expected.to include 'CassandraDaemon.java' }
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
          it { is_expected.to include "LOG=\"#{log_root}" }
        end
      end
    end

    context 'has a single place for config' do
      describe file '/var/lib/datastax-agent/conf' do
        it { is_expected.to be_symlink }
        it { is_expected.to be_linked_to '/etc/datastax-agent' }
      end
    end

    context 'has content in the correct log files' do
      describe file("/#{log_dir}/datastax-agent/agent.log") do
        it { is_expected.to be_file }
        describe '#content' do
          subject { super().content }
          it { is_expected.to include 'DataStax Agent version' }
        end
      end

      describe file("/#{log_dir}/datastax-agent/startup.log") do
        it { is_expected.to be_file }
      end
    end
  end

  describe 'Backups' do
    include Rspec::Shell::Expectations
    let(:backup_root_dir) { '/var/lib/cassandra' }

    describe 'Snapshot Tool' do
      describe file '/usr/local/sbin/snapshot-cassandra' do
        it { is_expected.to be_file }
        it { is_expected.to be_mode(755) }
      end

      describe file('/etc/cron.d/cassandra_weekly_snapshot') do
        it do
          is_expected.to contain(
            '0 13 * * 6 root /usr/local/sbin/snapshot-cassandra 2>&1 | ' \
            'logger -t snapshot-cassandra -p cron.info -s'
          )
        end
      end

      context 'has correct configuration' do
        describe file '/etc/cassandra/snapshots.conf' do
          it { is_expected.to be_file }
          it { is_expected.to be_mode(600) }
          describe '#content' do
            subject { super().content }
            it { is_expected.to include 'BUCKET=et-cassandra-backups-test' }
            it { is_expected.to include 'CHEF_ENVIRONMENT' }
            it { is_expected.to include 'REGION' }
            it { is_expected.to include 'SKIP_KEYSPACES' }
          end
        end
      end

      context 's3 upload fails' do
        let(:stubbed_env) { create_stubbed_env }

        before do
          stubbed_env.stub_command('s3cmd').returns_exitstatus 1
        end

        it 'indicates tarball could not be uploaded' do
          stdout, _stderr, status = stubbed_env.execute '/usr/local/sbin/snapshot-cassandra'
          expect(stdout).to contain 'S3 Upload failed. Retrying \('
          expect(stdout).to contain(
            'Could not upload /var/lib/cassandra/backup_work_dir/keyspace1-1.tar.gz' \
            ' in 5 tries. Skipping keyspace keyspace1 in data_dir /var/lib/cassandra/data.'
          )
          expect(status.exitstatus).to eq 0
          FileUtils.rm_rf(Dir.glob('/var/lib/cassandra/backup_work_dir/*'))
        end

        after do
          stubbed_env.cleanup
        end
      end

      context 'clean backup environment' do
        let(:stubbed_env) { create_stubbed_env }

        before do
          stubbed_env.stub_command('s3cmd').returns_exitstatus 0
        end

        it 'indicates snapshots cleared' do
          stdout, _stderr, _status = stubbed_env.execute '/usr/local/sbin/snapshot-cassandra'
          expect(stdout).to contain(
            'Requested clearing snapshot\(s\) for \[all keyspaces\]\n' \
            'Requested clearing snapshot\(s\) for \[all keyspaces\]\n'
          )
        end

        it 'runs without errors' do
          _stdout, _stderr, status = stubbed_env.execute '/usr/local/sbin/snapshot-cassandra'
          expect(status.exitstatus).to eq 0
        end

        after do
          stubbed_env.cleanup
        end
      end

      context 'tarball exists' do
        let(:tarball) { "#{backup_root_dir}/backup_work_dir/keyspace1-1.tar.gz" }
        before(:each) do
          File.open(tarball, 'w') { |f| f.write('temp data') }
        end

        describe command('/usr/local/sbin/snapshot-cassandra') do
          its(:exit_status) { should eq 1 }
          its(:stdout) do
            should contain("#{tarball} already exists! Bailing instead of overwriting it.")
          end
        end

        after(:each) do
          File.delete tarball
        end
      end

      context 'tar files changed as we read them' do
        let(:stubbed_env) { create_stubbed_env }
        let(:tar_stub) { stubbed_env.stub_command('tar') }

        before do
          tar_stub
            .outputs(
              'tar: keyspace1/FAKE_TABLE_ID/snapshots/FAKE_SNAPSHOT_ID/FAKE_TABLE-Data.db: file changed as we read it',
              to: :stderr
            )
            .returns_exitstatus 1
        end

        it 'indicates that it cannot make the tarball but finishes anyway' do
          stdout, _stderr, status = stubbed_env.execute '/usr/local/sbin/snapshot-cassandra'
          expect(stdout).to contain('tar failed. Retrying...')
          expect(stdout).to contain(
            "Could not create #{backup_root_dir}/backup_work_dir/keyspace1-1.tar.gz " \
            "in 5 tries. Skipping keyspace keyspace1 in data_dir #{backup_root_dir}/data."
          )
          expect(status.exitstatus).to eq 0
        end

        describe command('ls /var/lib/cassandra/backup_work_dir/*') do
          its(:stderr) { should contain 'ls: cannot access /var/lib/cassandra/backup_work_dir/\*: No such file or directory' }
        end

        after do
          stubbed_env.cleanup
        end
      end

      context 'no snapshots to back up' do
        let(:stubbed_env) { create_stubbed_env }
        let(:nodetool_stub) do
          stubbed_env
            .stub_command('nodetool')
            .with_args('-h', 'localhost', 'snapshot')
        end

        before do
          nodetool_stub.outputs(
            "Requested creating snapshot(s) for [all keyspaces] with snapshot name [FAKE_SNAPSHOT_ID]\n" \
            'Snapshot directory: FAKE_SNAPSHOT_ID'
          )
        end

        it 'indicates there is nothing to back up' do
          stdout, _stderr, _status =
            stubbed_env.execute '/usr/local/sbin/snapshot-cassandra'
          expect(stdout).to contain(
            'Nothing to back up in /var/lib/cassandra/data/keyspace1/\\*/' \
            'snapshots/FAKE_SNAPSHOT_ID\n'
          )
        end

        it 'exits with status 0' do
          _stdout, _stderr, status =
            stubbed_env.execute '/usr/local/sbin/snapshot-cassandra'
          expect(status.exitstatus).to eq 0
        end

        after do
          stubbed_env.cleanup
        end
      end
    end
  end
end
