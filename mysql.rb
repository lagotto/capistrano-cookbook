# create new database.yml unless it exists already
# you can set these passwords in config.json to keep them persistent
unless File.exists?("/var/www/#{node['rails']['name']}/shared/config/database.yml")
  node.set_unless['mysql']['server_root_password'] = SecureRandom.hex(8)
  node.set_unless['mysql']['server_repl_password'] = SecureRandom.hex(8)
  node.set_unless['mysql']['server_debian_password'] = SecureRandom.hex(8)
  database_exists = false
else
  database = YAML::load(IO.read("/var/www/#{node['rails']['name']}/shared/config/database.yml"))
  server_root_password = database[node['rails']['environment']]['password']

  node.set_unless['mysql']['server_root_password'] = server_root_password
  node.set_unless['mysql']['server_repl_password'] = server_root_password
  node.set_unless['mysql']['server_debian_password'] = server_root_password
  database_exists = true
end

template "/var/www/#{node['rails']['name']}/shared/config/database.yml" do
  source 'database.yml.erb'
  owner node['nginx']['user']
  group node['nginx']['group']
  mode 0644
end

include_recipe "mysql::server"
include_recipe "database::mysql"

# Create default MySQL database
# mysql_database "#{node['rails']['name']}_#{node['rails']['environment']}" do
#   connection(
#     :host     => 'localhost',
#     :username => 'root',
#     :password => node['mysql']['server_root_password']
#   )
#   action :create
# end
