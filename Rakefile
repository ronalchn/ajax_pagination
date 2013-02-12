require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :travis do
  serverport = IO.read(File.expand_path("../spec/PORT",__FILE__)).strip # port number that we are using
  serverslowport = IO.read(File.expand_path("../spec/SLOWPORT",__FILE__)).strip # port number that we are using
  r30serverport = IO.read(File.expand_path("../spec/R30PORT",__FILE__)).strip # port number that we are using

  system("cp spec/rails_app/db/development.sqlite3 spec/rails_app/db/test.sqlite3") # take a copy of the development database

  Bundler.with_clean_env do
    # startup test servers
    system("(export BUNDLE_GEMFILE=`pwd`/spec/rails_app/Gemfile; cd spec/rails_app/ && (bundle | grep -e 'Your bundle .*$') && RAILS_ENV=test bundle exec rails server -d --port=#{serverport})") # daemonized rails server
    system("(export BUNDLE_GEMFILE=`pwd`/spec/rails_app/Gemfile; cd spec/rails_app/ && (bundle | grep -e 'Your bundle .*$') && RAILS_ENV=test AJAX_DELAY=1.5 bundle exec rails server -d --port=#{serverslowport} -P tmp/pids/server2.pid)") # daemonized rails server
    system("(export BUNDLE_GEMFILE=`pwd`/spec/rails30_app/Gemfile; cd spec/rails30_app/ && (bundle | grep -e 'Your bundle .*$') && RAILS_ENV=test AJAX_DELAY=1.5 bundle exec rails server -d --port=#{r30serverport})") # daemonized rails server
  end
  system("bundle exec rake spec")
  unless $?.exitstatus == 0
    system("kill -9 `lsof -i :#{serverport} -t`") # kills rails server
    system("kill -9 `lsof -i :#{serverslowport} -t`") # kills rails server
    system("kill -9 `lsof -i :#{r30serverport} -t`") # kills rails server
    raise "spec failed!" 
  end
  system("kill -9 `lsof -i :#{serverport} -t`") # kills rails server
  system("kill -9 `lsof -i :#{serverslowport} -t`") # kills rails server
  system("kill -9 `lsof -i :#{r30serverport} -t`") # kills rails server
end
