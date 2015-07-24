actions :create, :delete
default_action :create

attribute :id, kind_of: String, name_attribute: true
attribute :aws_access_key_id, kind_of: String
attribute :aws_secret_access_key, kind_of: String
attribute :bucket, kind_of: String, required: true
attribute :region, kind_of: String, default: 'us-east-1'
attribute :type, equal_to: %w(snapshots incrementals)
attribute :days, kind_of: Integer, required: true

attr_accessor :exists
