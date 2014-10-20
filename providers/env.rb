def whyrun_supported?
  true
end

use_inline_resources

def load_current_resource
  @current_resource = Chef::Resource::CapistranoTemplate.new(new_resource.name)
end

action :load do
  # make sure the dotenv gem is installed
  require 'dotenv'

  # load ENV variables from .env
  # all user-specific configuration settings are stored in .env
  Dotenv.load
end

action :copy do
  # create shared folder if it doesn't exist
  directory "/var/www/#{new_resource.name}/shared" do
    owner new_resource.user
    group new_resource.group
    mode '0755'
  end

  # copy .env from current to shared
  remote_file "/var/www/#{new_resource.name}/shared/.env" do
    source "file:///var/www/#{new_resource.name}/current/.env"
    owner new_resource.user
    group new_resource.group
    mode '0644'
  end
end
