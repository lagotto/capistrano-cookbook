define :db_app, :template => 'database.yml.erb', :local => false, :enable => true do

  application_name = params[:name]
  filename = "/var/www/#{node['capistrano']['application']}/shared/config/database.yml"

  template filename do
    source params[:template]
    local params[:local]
    owner node['capistrano']['deploy_user']
    group node['capistrano']['group']
    mode '0644'
    cookbook params[:cookbook] if params[:cookbook]
    variables(
      :application_name => application_name,
      :params           => params
    )
    action :create_if_missing
  end

  # if database.yml exists, read password for downstream use
  # this way we can use random passwords without a Chef server
  if File.exists? filename
    database = YAML::load(IO.read(filename))
    node.set_unless['capistrano']['db_password'] = database['production']['password']
  end
end
