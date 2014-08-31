actions :setup, :bundle_install, :precompile_assets, :restart
default_action :setup

attribute :name, :kind_of => String, :name_attribute => true
attribute :user, :kind_of => String, :default => "www-data"
attribute :group, :kind_of => String, :default => "www-data"
attribute :rails_env, :kind_of => String, :default => "production"
attribute :linked_dirs, :kind_of => [Array, NilClass], :default => nil
attribute :linked_files, :kind_of => [Array, NilClass], :default => nil
attribute :config_files, :kind_of => [Array, NilClass], :default => nil
