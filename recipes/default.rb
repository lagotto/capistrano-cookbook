# make sure we have a current Ruby
include_recipe 'apt'
include_recipe 'ruby'

# configure nginx virtual host
web_app node['capistrano']['application'] do
  docroot "/var/www/#{node['capistrano']['application']}/current/public"
  server_name node['hostname']
  rails_env node['capistrano']['rails_env']
  cookbook "passenger_nginx"
end

# create folders needed for config files and web server document root
%w{ current/public shared/config }.each do |dir|
  directory "/var/www/#{node['capistrano']['application']}/#{dir}" do
    owner node['capistrano']['deploy_user']
    group node['capistrano']['group']
    mode 0755
    recursive true
  end
end

# symlink shared files and folders
node['capistrano']['linked_files'].each do |file|
  bash "ln -fs /var/www/#{node['capistrano']['application']}/shared/#{file} #{file}" do
    cwd "/var/www/#{node['capistrano']['application']}/current"
  end
end

node['capistrano']['linked_dirs'].each do |dir|
  bash "ln -fs /var/www/#{node['capistrano']['application']}/shared/#{dir} #{dir}" do
    cwd "/var/www/#{node['capistrano']['application']}/current"
  end
end
