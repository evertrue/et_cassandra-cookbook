# Support whyrun
def whyrun_supported?
  true
end

action :create do
  if @current_resource.exists
    Chef::Log.info "#{@new_resource} already exists - nothing to do"
  else
    Chef::Log.info "Creating LifeCycle #{@new_resource}"
    converge_by("Create #{@new_resource}") do
      create_lifecycle
    end
    @new_resource.updated_by_last_action(true)
  end
end

action :update do
  if @current_resource.exists
    Chef::Log.info "Updating LifeCycle #{@new_resource}"
    converge_by("Update #{@new_resource}") do
      update_lifecycle
    end
  else
    Chef::Log.info "Creating LifeCycle #{@new_resource}"
    converge_by("Create #{@new_resource}") do
      create_lifecycle
    end
  end

  @new_resource.updated_by_last_action true
end

action :delete do
  if @current_resource.exists
    Chef::Log.info "Deleting LifeCycle #{@new_resource}"
    converge_by("Delete #{@new_resource}") do
      delete_lifecycle
    end
    @new_resource.updated_by_last_action(true)
  else
    Chef::Log.info "#{@current_resource} doesn't exist - nothing to do"
  end
end

def options
  @options ||= begin
    options = {
      bucket: @new_resource.bucket,
      region: @new_resource.region
    }

    if @new_resource.aws_access_key_id
      options[:aws_access_key_id] = @new_resource.aws_access_key_id
      options[:aws_secret_access_key] = @new_resource.aws_secret_access_key
    end
    options
  end
end

def delete_lifecycle
  EverTools::AwsBucketLifecycle.new(options).remove(id)
end

def update_lifecycle
  lifecycle = EverTools::AwsBucketLifecycle.new(
    options.merge(env: node.chef_environment, node_fqdn: node['fqdn'])
  )
  lifecycle.update(@new_resource.id, @new_resource.days, @new_resource.type)
end

def create_lifecycle
  lifecycle = EverTools::AwsBucketLifecycle.new(
    options.merge(env: node.chef_environment, node_fqdn: node['fqdn'])
  )
  lifecycle.create(@new_resource.id, @new_resource.days, @new_resource.type)
end

def lifecycle_exists?(id)
  EverTools::AwsBucketLifecycle.new(options).rule(id)
end

def load_current_resource
  @current_resource = Chef::Resource::EtCassandraBackupLifecycle.new(@new_resource.id)
  @current_resource.id(@new_resource.id)
  @current_resource.bucket(@new_resource.bucket)
  @current_resource.region(@new_resource.region)

  @current_resource.exists = true if lifecycle_exists? @current_resource.id
end
