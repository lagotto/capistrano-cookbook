actions :create
default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :application, :kind_of => String, :default => "app"
attribute :source, :kind_of => String, :default => ""
attribute :deploy_user, :kind_of => String, :default => "www-data"
attribute :group, :kind_of => String, :default => "www-data"
attribute :params, :kind_of => Hash, :default => {}
