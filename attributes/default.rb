require 'securerandom'

default['capistrano']['application'] = "app"
default['capistrano']['rails_env'] = "production"
default['capistrano']['deploy_user'] = "vagrant"
default['capistrano']['group'] = "www-data"

default['capistrano']['db_user'] = "root"
default['capistrano']['db_password'] = SecureRandom.hex(8)
default['capistrano']['db_host'] = "localhost"
