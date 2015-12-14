default['ruby']['deploy_user'] = "vagrant"
default['ruby']['deploy_group'] = "vagrant"
default['ruby']['rails_env'] = "development"
default['ruby']['enable_capistrano'] = false

default['application'] = "capistrano"

default['nodejs']['repo'] = 'https://deb.nodesource.com/node_0.12'

default['consul']['service_mode'] = 'cluster'
default['consul']['atlas_cluster'] = ENV['CONSUL_SERVERS'] || node['hostname']
default['consul']['atlas_token'] = ENV['ATLAS_TOKEN']

default['rsyslog']['server'] = '127.0.0.1'
default['rsyslog']['port'] = 514
node['rsyslog']['custom_remote'] = [{ 'server' => node['rsyslog']['server'],
                                      'port' => node['rsyslog']['port'] }]
