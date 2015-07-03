default['ruby']['deploy_user'] = "vagrant"
default['ruby']['deploy_group'] = "vagrant"
default['ruby']['rails_env'] = "development"

default['consul']['servers'] = ENV['CONSUL_SERVERS'] || [ENV['HOSTNAME']]
default['consul']['service_mode'] = 'cluster'
