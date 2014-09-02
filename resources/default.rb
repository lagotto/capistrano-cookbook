actions :deploy, :config, :bundle_install, :precompile_assets, :migrate, :restart
default_action :deploy

attribute :name, :kind_of => String, :name_attribute => true
attribute :user, :kind_of => String, :default => node['ruby']['user']
attribute :group, :kind_of => String, :default => node['ruby']['group']
attribute :rails_env, :kind_of => String, :default => node['ruby']['rails_env']
