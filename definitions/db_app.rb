define :db_app, :template => 'database.yml.erb', :local => false, :enable => true do

  application_name = params[:name]
  filename = "/var/www/#{node['capistrano']['application']}/shared/config/database.yml"

  if File.exists? filename
    # if database.yml exists, run migrations

    bash "RAILS_ENV=#{node['capistrano']['rails_env']} /usr/local/bin/bundle exec rake db:migrations" do
      user node['capistrano']['deploy_user']
      cwd "/var/www/#{node['capistrano']['application']}/current"
    end
  else
    # create database.yml, copy it, and setup database

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
      notifies :run, "file[database.yml]", :immediately
    end

    file "database.yml" do
      path "/var/www/#{node['capistrano']['application']}/shared/config/database.yml"
      content ::File.open("/var/www/#{node['capistrano']['application']}/current/config/database.yml").read
      owner node['capistrano']['deploy_user']
      group node['capistrano']['group']
      mode 0644
    end

    bash "RAILS_ENV=#{node['capistrano']['rails_env']} /usr/local/bin/bundle exec rake db:setup" do
      user node['capistrano']['deploy_user']
      cwd "/var/www/#{node['capistrano']['application']}/current"
    end
  end
end
