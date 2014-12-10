default['ruby']['deploy_user'] = "vagrant"
default['ruby']['deploy_group'] = "vagrant"
default['ruby']['rails_env'] = "development"
default['npm']['npm_config_prefix'] = "/home/#{node['ruby']['deploy_user']}/npm-config"
