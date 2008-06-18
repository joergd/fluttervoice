require 'mongrel_cluster/recipes'
# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true.

set :domain, "www.fluttervoice.co.za"
role :web, domain
role :app, domain
role :db,  domain, :primary => true
#role :scm, domain

# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The deploy_to path must be the path on each machine that will
# form the root of the application path.

set :application, "fluttervoice"
set :deploy_to, "/var/www/apps/#{application}"

# XXX we may not need this - it doesn't work on windows
#set :user, 'joergd'
#set :repository, "http://brea.kfa.st/svn/stopthehippies/trunk/www/"
#set :svn_username, "joergd"
#set :svn_password, "int3rn3t"
set :rails_env, "production"

default_run_options[:pty] = true
set :repository,  "git@github.com:joergd/fluttervoice.git"
set :scm, "git"
set :scm_passphrase, "int3rn3t" #This is your custom users password
set :user, "joergd"
set :branch, "master"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1


# Automatically symlink these directories from current/public to shared/public.
set :app_symlinks, %w{blog}

# =============================================================================
# SPECIAL OPTIONS
# =============================================================================
# These options allow you to tweak deprec behaviour

# If you do not keep database.yml in source control, set this to false.
# After new code is deployed, deprec will symlink current/config/database.yml 
# to shared/config/database.yml
#
# You can generate shared/config/database.yml with 'cap generate_database_yml'
#
# set :database_yml_in_scm, true

# =============================================================================
# APACHE OPTIONS
# =============================================================================
set :apache_server_name, domain
set :apache_server_aliases, %w{fluttervoice.com fluttervoice.co.uk}
# set :apache_default_vhost, true # force use of apache_default_vhost_config
# set :apache_default_vhost_conf, "/usr/local/apache2/conf/default.conf"
set :apache_conf, "/usr/local/apache2/conf/apps/#{application}.conf"
set :apache_ctl, "/etc/init.d/httpd"
set :apache_proxy_port, 8000
set :apache_proxy_servers, 4
set :apache_proxy_address, "127.0.0.1"
# set :apache_ssl_enabled, true
# set :apache_ssl_ip, "127.0.0.1"
# set :apache_ssl_forward_all, false
# set :apache_ssl_chainfile, false


# =============================================================================
# MONGREL OPTIONS
# =============================================================================
set :mongrel_servers, apache_proxy_servers
set :mongrel_port, apache_proxy_port
set :mongrel_address, apache_proxy_address
set :mongrel_environment, "production"
set :mongrel_config, "/etc/mongrel_cluster/#{application}.yml"
# set :mongrel_user_prefix,  'mongrel_'
# set :mongrel_user, mongrel_user_prefix + application
# set :mongrel_group_prefix,  'app_'
# set :mongrel_group, mongrel_group_prefix + application

# =============================================================================
# MYSQL OPTIONS
# =============================================================================


# =============================================================================
# SSH OPTIONS
# =============================================================================
ssh_options[:keys] = %w(/Users/joerg/.ssh/id_rsa)
ssh_options[:port] = 2222


namespace :deploy do

  task :after_setup do
  end
  
  task :after_update_code do
    run <<-EOF
      cd #{release_path}/public && 
      chmod 777 javascripts
    EOF

    run <<-EOF
      cd #{release_path}/public && 
      mkdir account &&
      chmod 777 account
    EOF

    run <<-EOF
      rm -rf #{release_path}/public/blog &&
      cd #{release_path}/public &&
      ln -s #{shared_path}/blog blog
    EOF

  end

end

