# use the capistrano LWRP

capistrano node['capistrano']['application'] do
  rails_env "development"
  action [:create, :symlink]
end


# configure database
# capistrano_database node['capistrano']['application'] do
#   username node['capistrano']['db_user']
#   password node['capistrano']['db_password']
#   host node['capistrano']['db_host']
#   action [:config, :setup, :migrate]
# end

