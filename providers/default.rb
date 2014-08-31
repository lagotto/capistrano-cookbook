use_inline_resources

def whyrun_supported?
  true
end

def load_current_resource
  @current_resource = Chef::Resource::Capistrano.new(new_resource.name)
end

action :setup do
  # create shared folders
  %w{ #{new_resource.name} #{new_resource.name}/current #{new_resource.name}/shared #{new_resource.name}/shared/config  #{new_resource.name}/shared/vendor }.each do |dir|
    directory "/var/www/#{dir}" do
      owner new_resource.user
      group new_resource.group
      mode '0755'
      recursive true
    end
  end

  # create additional folders that should be linked
  Array(new_resource.linked_dirs).each do |dir|
    directory "/var/www/#{new_resource.name}/shared/#{dir}" do
      owner new_resource.user
      group new_resource.group
      mode '0755'
      recursive true
    end
  end

  # create config files from templates in parent cookbook, respect folder location
  Array(new_resource.templates).each do |file|
    template "/var/www/#{new_resource.name}/shared/#{file}" do
      source file.split("/").last
      owner new_resource.user
      group new_resource.group
      mode '0755'
    end
  end

  # symlink shared folders
  Array(new_resource.linked_dirs).each do |dir|
    link "/var/www/#{new_resource.name}/shared/#{dir}" do
      to "/var/www/#{new_resource.name}/current/#{dir}"
    end
  end

  # symlink files
  Array(new_resource.linked_files + new_resource.templates).each do |file|
    link "/var/www/#{new_resource.name}/shared/#{file}" do
      to "/var/www/#{new_resource.name}/current/#{file}"
    end
  end
end

action :bundle_install do
  # create folder if it doesn't exist
  %w{ #{new_resource.name} #{new_resource.name}/current }.each do |dir|
    directory "/var/www/#{dir}" do
      owner new_resource.user
      group new_resource.group
      mode '0755'
      recursive true
    end
  end

  # provide Gemfile if it doesn't exist, e.g. during testing
  cookbook_file "Gemfile" do
    path "/var/www/#{new_resource.name}/current/Gemfile"
    owner new_resource.user
    group new_resource.group
    cookbook "capistrano"
    action :create
  end

  # provide Gemfile.lock if it doesn't exist and we need it
  cookbook_file "Gemfile.lock" do
    path "/var/www/#{new_resource.name}/current/Gemfile.lock"
    owner new_resource.user
    group new_resource.group
    cookbook "capistrano"
    not_if { new_resource.rails_env == "development" }
    action :create
  end

  bash "bundle install" do
    user new_resource.user
    environment 'RAILS_ENV' => new_resource.rails_env
    cwd "/var/www/#{new_resource.name}/current"
    if new_resource.rails_env == "development"
      code "bundle install"
    else
      code "bundle install --path vendor/bundle --deployment --without development test"
    end
  end
end

action :precompile_assets do
  # create folder if it doesn't exist
  %w{ #{new_resource.name} #{new_resource.name}/current }.each do |dir|
    directory "/var/www/#{dir}" do
      owner new_resource.user
      group new_resource.group
      mode '0755'
      recursive true
    end
  end

  # provide Rakefile if it doesn't exist, e.g. during testing
  cookbook_file "Rakefile" do
    path "/var/www/#{new_resource.name}/current/Rakefile"
    owner new_resource.user
    group new_resource.group
    cookbook "capistrano"
    action :create
  end

  bash "rake assets:precompile" do
    user node['capistrano']['deploy_user']
    environment 'RAILS_ENV' => new_resource.rails_env
    cwd "/var/www/#{new_resource.name}/current"
    code "bundle exec rake assets:precompile"
    not_if { new_resource.rails_env == "development" }
    new_resource.updated_by_last_action(true)
  end
end

action :restart do
  bash "restart rails application" do
    cwd  "/var/www/#{new_resource.name}/current"
    code "mkdir -p tmp && touch tmp/restart.txt"
  end
end
