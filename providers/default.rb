use_inline_resources

def whyrun_supported?
  true
end

def load_current_resource
  @current_resource = Chef::Resource::Capistrano.new(new_resource.name)
end

action :deploy do
end

action :config do
  # create shared folders
  %W{ #{new_resource.name} #{new_resource.name}/current #{new_resource.name}/current #{new_resource.name}/shared }.each do |dir|
    directory "/var/www/#{dir}" do
      owner new_resource.deploy_user
      group new_resource.group
      mode '0755'
      recursive true
    end
  end

  # create config files from templates in parent cookbook
  Array(new_resource.templates).each do |path|
    files = path.split("/")
    files.each_index do |i|
      if i + 1 < files.length
        # create parent folders of file with correct permissions
        # in both the shared and current folder
        dir = files[0..i].join("/")
        %w{ current shared }.each do |parent_dir|
          directory "/var/www/#{new_resource.name}/#{parent_dir}/#{dir}" do
            owner new_resource.deploy_user
            group new_resource.group
            mode '0755'
          end
        end
      else
        # create file from template and symlink it
        template "/var/www/#{new_resource.name}/shared/#{path}" do
          source files.last
          owner new_resource.deploy_user
          group new_resource.group
          mode '0755'
        end

        link "/var/www/#{new_resource.name}/current/#{path}" do
          to "/var/www/#{new_resource.name}/shared/#{path}"
        end
      end
    end
  end
end

action :bundle_install do
  run_context.include_recipe 'ruby'

  # provide Gemfile if it doesn't exist, e.g. during testing
  cookbook_file "Gemfile" do
    path "/var/www/#{new_resource.name}/current/Gemfile"
    owner new_resource.deploy_user
    group new_resource.group
    cookbook "capistrano"
    action :create
  end

  # provide Gemfile.lock if it doesn't exist and we need it
  cookbook_file "Gemfile.lock" do
    path "/var/www/#{new_resource.name}/current/Gemfile.lock"
    owner new_resource.deploy_user
    group new_resource.group
    cookbook "capistrano"
    if new_resource.rails_env == "development"
      action :delete
    else
      action :create
    end
  end

  # make sure we can use the bundle command
  bash "bundle install" do
    user new_resource.deploy_user
    cwd "/var/www/#{new_resource.name}/current"
    if new_resource.rails_env == "development"
      code "bundle install --no-deployment"
    else
      code "bundle install --path vendor/bundle --deployment --without development test"
    end
  end
end

action :precompile_assets do
  run_context.include_recipe 'ruby'

  # provide Rakefile if it doesn't exist, e.g. during testing
  cookbook_file "Rakefile" do
    path "/var/www/#{new_resource.name}/current/Rakefile"
    owner new_resource.deploy_user
    group new_resource.group
    cookbook "capistrano"
    action :create
  end

  bash "bundle exec rake assets:precompile" do
    user new_resource.deploy_user
    environment 'RAILS_ENV' => new_resource.rails_env
    cwd "/var/www/#{new_resource.name}/current"
    not_if { new_resource.rails_env == new_resource.rails_env }
    new_resource.updated_by_last_action(true)
  end
end

action :migrate do
  run_context.include_recipe 'ruby'

  # load/reload seed data
  bash "bundle exec rake db:seed" do
    user new_resource.deploy_user
    environment 'RAILS_ENV' => new_resource.rails_env
    cwd "/var/www/#{new_resource.name}/current"
    new_resource.updated_by_last_action(true)
  end

  # run database migrations
  bash "bundle exec rake db:migrate" do
    user new_resource.deploy_user
    environment 'RAILS_ENV' => new_resource.rails_env
    cwd "/var/www/#{new_resource.name}/current"
    new_resource.updated_by_last_action(true)
  end
end

action :restart do
  execute "restart" do
    cwd  "/var/www/#{new_resource.name}/current"
    command "mkdir -p tmp && touch tmp/restart.txt"
  end
end
