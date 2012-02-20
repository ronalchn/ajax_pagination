require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :travis do
  serverport = IO.read(File.expand_path("../spec/PORT",__FILE__)).strip # port number that we are using
  system("cp spec/rails_app/db/development.sqlite3 spec/rails_app/db/test.sqlite3") # take a copy of the development database
  system("(cd spec/rails_app/ && bundle install > /dev/null 2>&1 && RAILS_ENV=development bundle exec rails server -d --port=#{serverport})") # daemonized rails server
  system("bundle install > /dev/null 2>&1")
  system("bundle exec rake spec")
  result = $?.exitstatus
  system("kill -9 `lsof -t -i :#{serverport}`") # kills rails server
  raise "spec failed!" unless result == 0
end
