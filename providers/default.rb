use_inline_resources

def whyrun_supported?
  true
end

def load_current_resource
  @current_resource = Chef::Resource::Capistrano.new(new_resource.name)
end

action :config do
  # create shared folders
  %W{ #{new_resource.name} #{new_resource.name}/current #{new_resource.name}/current #{new_resource.name}/shared }.each do |dir|
    directory "/var/www/#{dir}" do
      owner new_resource.user
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

action :restart do
  bash "restart rails application" do
    cwd  "/var/www/#{new_resource.name}/current"
    code "mkdir -p tmp && touch tmp/restart.txt"
  end
end
