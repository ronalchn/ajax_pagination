require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :travis do
  serverport = IO.read(File.expand_path("../spec/PORT",__FILE__)).strip # port number that we are using
  system("cp spec/rails_app/db/development.sqlite3 spec/rails_app/db/test.sqlite3") # take a copy of the development database
  system("mkdir -p spec/rails_app/vendor/assets/javascripts") # directory to plonk javascripts from dependent gems
  # obtain jquery javascript assets (this is because sprockets cannot find these files otherwise, when going through nested bundles)
  # Note that the spec/rails_app/vendor directory is .gitignore because these are generated files
  system("cp `bundle show jquery-rails`/vendor/assets/javascripts/* spec/rails_app/vendor/assets/javascripts/")
  system("cp `bundle show jquery-historyjs`/vendor/assets/javascripts/* spec/rails_app/vendor/assets/javascripts/")
  system("(cd spec/rails_app/ && RAILS_ENV=test bundle exec rails server -d --port=#{serverport})") # daemonized rails server
  system("bundle exec rake spec")
  unless $?.exitstatus == 0
    system("kill -9 `lsof -i :#{serverport} -t`") # kills rails server
    raise "spec failed!" 
  end
  system("kill -9 `lsof -i :#{serverport} -t`") # kills rails server
end
