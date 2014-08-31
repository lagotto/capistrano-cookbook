actions :deploy, :config, :bundle_install, :precompile_assets, :migrate, :restart
default_action :deploy

attribute :name, :kind_of => String, :name_attribute => true
attribute :deploy_user, :kind_of => String, :default => "www-data"
attribute :group, :kind_of => String, :default => "www-data"
attribute :rails_env, :kind_of => String, :default => "production"
attribute :templates, :kind_of => [Array, NilClass], :default => nil
