require 'spec_helper'

context 'Repair Jobs' do
  describe file('/usr/local/bin/cassandra-repair') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 755 }
  end

  describe file('/etc/cron.d/cassandra_repair') do
    it { is_expected.to be_file }
    its(:content) { is_expected.to match(/^20 4 /) }
  end
end
