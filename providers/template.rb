use_inline_resources

def whyrun_supported?
  true
end

def load_current_resource
  @current_resource = Chef::Resource::CapistranoTemplate.new(new_resource.name)
end

action :create do
  # create file from template in parent cookbook
  files = new_resource.name.split("/")
  files.each_index do |i|
    if i + 1 < files.length
      # create parent folders of file with correct permissions
      # in both the shared and current folder
      dir = files[0..i].join("/")
      %w{ current shared }.each do |parent_dir|
        directory "/var/www/#{new_resource.application}/#{parent_dir}/#{dir}" do
          owner new_resource.deploy_user
          group new_resource.group
          mode "0755"
        end
      end
    else
      # create file from template
      %w{ current shared }.each do |parent_dir|
        template "/var/www/#{new_resource.application}/#{parent_dir}/#{new_resource.name}" do
          source new_resource.source
          owner new_resource.deploy_user
          group new_resource.group
          mode "0755"
          variables(
            :application => new_resource.application,
            :params      => new_resource.params
          )
        end
      end
    end
  end
end
