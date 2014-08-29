def whyrun_supported?
  true
end

def load_current_resource
  @current_resource = Chef::Resource::CapistranoDatabase.new(new_resource.name)
end

action :config do
  template "/var/www/#{new_resource.name}/shared/config/database.yml" do
    source 'database.yml.erb'
    owner node['capistrano']['deploy_user']
    group node['capistrano']['group']
    mode '0644'
    variables(
      :application => new_resource.name,
      :username    => new_resource.username,
      :password    => new_resource.password,
      :host        => new_resource.host,
      :adapter     => new_resource.adapter
    )
    new_resource.updated_by_last_action(true)
  end
end

action :setup do
  bash "bundle exec rake db:setup" do
    user node['capistrano']['deploy_user']
    environment 'RAILS_ENV' => node['capistrano']['rails_env']
    cwd "/var/www/#{node['capistrano']['application']}/current"
  end
  new_resource.updated_by_last_action(true)
end

action :migrate do
  bash "bundle exec rake db:migrate" do
    user node['capistrano']['deploy_user']
    environment 'RAILS_ENV' => node['capistrano']['rails_env']
    cwd "/var/www/#{node['capistrano']['application']}/current"
  end
  new_resource.updated_by_last_action(true)
end

action :drop do
  bash "bundle exec rake db:drop" do
    user node['capistrano']['deploy_user']
    environment 'RAILS_ENV' => node['capistrano']['rails_env']
    cwd "/var/www/#{node['capistrano']['application']}/current"
  end
  new_resource.updated_by_last_action(true)
end

action :cleanup do
  file new_resource.config_file do
    action :delete
  end
  new_resource.updated_by_last_action(true)
end
