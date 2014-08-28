define :db_app, :template => 'database.yml.erb', :local => false, :enable => true do

  application_name = params[:name]
  filename = "/var/www/#{node['capistrano']['application']}/shared/config/database.yml"

  if File.exists? filename
    # if database.yml exists, run migrations

    bash "RAILS_ENV=#{['capistrano']['rails_env']} rake db:migrations" do
      cwd "/var/www/#{node['capistrano']['application']}/current"
    end
  else
    # create database.yml, symlink it, and setup database

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
      action :create
    end

    bash "ln -fs /var/www/#{node['capistrano']['application']}/shared/config/database.yml config/database.yml" do
      cwd "/var/www/#{node['capistrano']['application']}/current"
    end

    bash "RAILS_ENV=#{['capistrano']['rails_env']} rake db:setup" do
      cwd "/var/www/#{node['capistrano']['application']}/current"
    end
  end
end
