actions :config, :setup, :migrate, :drop, :cleanup
default_action :config

attribute :name, :kind_of => String, :name_attribute => true
attribute :username, :kind_of => String, :default => node['capistrano']['db_user']
attribute :password, :kind_of => String, :default => node['capistrano']['db_password']
attribute :host, :kind_of => String, :default => node['capistrano']['db_host']
attribute :adapter, :kind_of => String, :default => "myslq2"
