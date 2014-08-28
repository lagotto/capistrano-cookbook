# make sure we have a current Ruby
include_recipe 'apt'
include_recipe 'ruby'

# create folders needed for config files, vendored gems, and web server document root
%w{ current/public current/vendor/bundle shared/vendor_bundle shared/config }.each do |dir|
  directory "/var/www/#{node['capistrano']['application']}/#{dir}" do
    owner node['capistrano']['deploy_user']
    group node['capistrano']['group']
    mode 0755
    recursive true
  end

  bash "ln -fs /var/www/#{node['capistrano']['application']}/shared/vendor_bundle vendor/bundle" do
    user node['capistrano']['deploy_user']
    cwd "/var/www/#{node['capistrano']['application']}/current"
  end
end

# symlink shared files and folders, create folder (but not file) if it doesn't exist
node['capistrano']['linked_files'].each do |file|
  next if ["config/database.yml", "config/settings.yml"].include?(file)

  bash "ln -fs /var/www/#{node['capistrano']['application']}/shared/#{file} #{file}" do
    user node['capistrano']['deploy_user']
    cwd "/var/www/#{node['capistrano']['application']}/current"
  end
end

node['capistrano']['linked_dirs'].each do |dir|
  directory "/var/www/#{node['capistrano']['application']}/shared/#{dir}" do
    owner node['capistrano']['deploy_user']
    group node['capistrano']['group']
    mode 0755
    recursive true
  end

  bash "ln -fs /var/www/#{node['capistrano']['application']}/shared/#{dir} #{dir}" do
    user node['capistrano']['deploy_user']
    cwd "/var/www/#{node['capistrano']['application']}/current"
  end
end

# configure nginx virtual host
web_app node['capistrano']['application'] do
  docroot "/var/www/#{node['capistrano']['application']}/current/public"
  server_name node['hostname']
  rails_env node['capistrano']['rails_env']
  cookbook "passenger_nginx"
end
