# config valid only for current version of Capistrano
lock '3.5'

set :application, 'kontes-terbuka'
set :repo_url, 'git@github.com:donjar/kontes-terbuka.git'
set :branch, 'production'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/ktom/kontes-terbuka'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml',
                                                 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache',
                                               'tmp/sockets', 'vendor/bundle',
                                               'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :ssh_options, forward_agent: true, port: 1729
set :rails_env, 'production'

namespace :delayed_job do
  desc 'Restart delayed_job'
  task :restart do
    on roles(:app) do
      # Source the environment variables listed in /etc/default/unicorn
      execute 'source /etc/default/unicorn'
      execute 'RAILS_ENV=production ~/.rvm/bin/rvm default do ' \
        "#{deploy_to}/current/bin/delayed_job restart"
    end
  end
end

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app) do
      upload! StringIO.new(File.read('config/deploy/restart.sh')),
              "#{deploy_to}/restart.sh"
      execute :chmod, "u+x #{deploy_to}/restart.sh"
      execute "sudo #{deploy_to}/restart.sh"
    end
  end

  after :publishing, 'deploy:restart'
  after :publishing, 'delayed_job:restart'
  after :finishing, 'deploy:cleanup'
  after :finishing, 'deploy:sitemap:refresh'
end
