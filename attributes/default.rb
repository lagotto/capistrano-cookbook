default['capistrano']['application'] = "app"
default['capistrano']['rails_env'] = "production"
default['capistrano']['deploy_user'] = "vagrant"
default['capistrano']['group'] = "www-data"

default['capistrano']['db_user'] = "root"
default['capistrano']['db_password'] = node['mysql']['server_root_password']
default['capistrano']['db_host'] = "localhost"

default['capistrano']['linked_files'] = []
default['capistrano']['linked_dirs'] = []
