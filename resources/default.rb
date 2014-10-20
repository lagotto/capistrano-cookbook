actions :deploy, :config, :bundle_install, :precompile_assets, :migrate, :restart
default_action :deploy

attribute :name, :kind_of => String, :name_attribute => true
attribute :user, :kind_of => String, :default => ENV['DEPLOY_USER']
attribute :group, :kind_of => String, :default => ENV['DEPLOY_GROUP']
attribute :rails_env, :kind_of => String, :default => ENV['RAILS_ENV']
