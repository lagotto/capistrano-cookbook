def whyrun_supported?
  true
end

use_inline_resources

def load_current_resource
  @current_resource = Chef::Resource::CapistranoTemplate.new(new_resource.name)
end

action :load do
  # Load ENV variables
  # convert all hash values into strings
  config = YAML.load_file("/var/www/#{new_resource.name}/current/config/application.yml")
  config = Hash[config.map { |k, v| [k.to_s, v.to_s] }]
  ENV.update config
end

action :copy do
  # create shared and shared/config folders if they don't exist already
  %w{ shared shared/config }.each do |dir|
    directory "/var/www/#{new_resource.name}/#{dir}" do
      owner new_resource.user
      group new_resource.group
      mode '0755'
    end
  end

  # copy application.yml from current/config to shared/config
  remote_file "/var/www/#{new_resource.name}/shared/config/application.yml" do
    source "file:///var/www/#{new_resource.name}/current/config/application.yml"
  end
end
