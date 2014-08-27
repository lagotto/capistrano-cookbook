default['capistrano']['application'] = "app"
default['capistrano']['rails_env'] = "production"
default['capistrano']['deploy_user'] = "vagrant"
default['capistrano']['group'] = "www-data"

default['capistrano']['database'] = "#{node['capistrano']['application']}_#{node['capistrano']['rails_env']}"
default['capistrano']['db_user'] = "root"
default['capistrano']['db_password'] = node['mysql']['server_root_password']
default['capistrano']['db_host'] = "localhost"
