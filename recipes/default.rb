# create folders needed for config files and web server document root
%w{ current shared/config }.each do |dir|
  directory "/var/www/#{node['capistrano']['application']}/#{dir}" do
    owner node['capistrano']['deploy_user']
    group node['capistrano']['group']
    mode 0755
    recursive true
  end
end

# configure nginx virtual host
web_app node['capistrano']['application'] do
  docroot "/var/www/#{node['capistrano']['application']}/current/public"
  server_name node['hostname']
  rails_env node['capistrano']['rails_env']
  cookbook "passenger_nginx"
end

# create database configuration file
db_app node['capistrano']['application'] do
  host node['capistrano']['db_host']
  username node['capistrano']['db_user']
  password node['capistrano']['db_password']
  cookbook "capistrano"
end

include_recipe 'mysql::server'
include_recipe "database::mysql"

# create database
# connection_info = {
#   :host     => node['capistrano']['db_host'],
#   :username => node['capistrano']['db_user'],
#   :password => node['capistrano']['db_password']
# }
# mysql_database "#{node['capistrano']['application']}_#{node['capistrano']['rails_env']}" do
#   connection_info
#   action :create
# end
