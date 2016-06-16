module EverTools
  class AwsBucketLifecycle
    def initialize(options)
      @options = options
    end

    def create(id, days, type)
      bucket_obj = s3.directories.get(@options[:bucket]) || raise("Bucket #{@options[:bucket]} not found")
      rule_options = {
        'ID' => id,
        'Prefix' => "cassandra/#{@options[:env]}/#{@options[:node_fqdn]}/#{type}",
        'Expiration' => { 'Days' => days },
        'Enabled' => true
      }
      raise "Rule #{id} aleady exists!" if rule(rule_options['ID'])
      final_rules_list = rules | [rule_options]
      s3.put_bucket_lifecycle(bucket_obj.key, 'Rules' => final_rules_list)
    end

    def update(id, days, type)
      bucket_obj = s3.directories.get(@options[:bucket]) || raise("Bucket #{@options[:bucket]} not found")
      rule_options = {
        'ID' => id,
        'Prefix' => "cassandra/#{@options[:env]}/#{@options[:node_fqdn]}/#{type}",
        'Expiration' => { 'Days' => days },
        'Enabled' => true
      }
      final_rules_list =
        rules.reject { |r| r['ID'] == rule_options['ID'] } +
        [rule_options]
      s3.put_bucket_lifecycle(bucket_obj.key, 'Rules' => [final_rules_list])
    end

    def remove(id)
      bucket_obj = s3.directories.get(@options[:bucket]) || raise("Bucket #{@options[:bucket]} not found")
      final_rules_list = rules.reject { |r| r['ID'] == id }
      s3.put_bucket_lifecycle(bucket_obj.key, 'Rules' => [final_rules_list])
    end

    def rule(id)
      rules.find { |i| i['ID'] == id }
    end

    private

    def rules
      @rules ||= begin
        s3.get_bucket_lifecycle(@options[:bucket]).data[:body]['Rules']
      rescue Excon::Errors::NotFound
        Chef::Log.debug "Bucket #{@options[:bucket]} has no lifecycle rules"
        []
      end
    end

    def s3
      @s3 ||= begin
        require 'fog'
        conn_opts = if @options[:aws_access_key_id]
                      {
                        aws_access_key_id: @options[:aws_access_key_id],
                        aws_secret_access_key: @options[:aws_secret_access_key]
                      }
                    else
                      { use_iam_profile: true }
                    end
        conn_opts[:path_style] = true
        conn_opts[:region] = @options[:region]
        Fog::Storage::AWS.new(conn_opts)
      end
    end
  end
end
