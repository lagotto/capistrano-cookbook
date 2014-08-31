actions :config
default_action :cconfig

attribute :name, :kind_of => String, :name_attribute => true
attribute :deploy_user, :kind_of => String, :default => "www-data"
attribute :group, :kind_of => String, :default => "www-data"
attribute :templates, :kind_of => [Array, NilClass], :default => nil
