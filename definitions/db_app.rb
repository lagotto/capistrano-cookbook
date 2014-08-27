define :db_app, :template => 'database.yml.erb', :local => false, :enable => true do

  application_name = params[:name]

  template "/var/www/#{node['capistrano']['application']}/shared/config/database.yml" do
    source params[:template]
    local params[:local]
    owner node['capistrano']['deploy_user']
    group node['capistrano']['deploy_user']
    mode '0644'
    cookbook params[:cookbook] if params[:cookbook]
    variables(
      :application_name => application_name,
      :params           => params
    )
  end
end

# # create new database.yml unless it exists already
# # you can set these passwords in config.json to keep them persistent
# unless File.exists?("/var/www/#{node['rails']['name']}/shared/config/database.yml")
#   node.set_unless['mysql']['server_root_password'] = SecureRandom.hex(8)
#   node.set_unless['mysql']['server_repl_password'] = SecureRandom.hex(8)
#   node.set_unless['mysql']['server_debian_password'] = SecureRandom.hex(8)
#   database_exists = false
# else
#   database = YAML::load(IO.read("/var/www/#{node['rails']['name']}/shared/config/database.yml"))
#   server_root_password = database[node['rails']['environment']]['password']

#   node.set_unless['mysql']['server_root_password'] = server_root_password
#   node.set_unless['mysql']['server_repl_password'] = server_root_password
#   node.set_unless['mysql']['server_debian_password'] = server_root_password
#   database_exists = true
# end
