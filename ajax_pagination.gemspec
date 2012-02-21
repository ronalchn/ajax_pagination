# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ajax_pagination/version"

Gem::Specification.new do |s|
  s.name        = "ajax_pagination"
  s.version     = AjaxPagination::VERSION
  s.authors     = ["Ronald Ping Man Chan"]
  s.email       = ["ronalchn@gmail.com"]
  s.homepage    = "https://github.com/ronalchn/ajax_pagination"
  s.summary     = %q{Handles AJAX pagination, changing the content when certain links are followed.}
  s.description = %q{Handles AJAX pagination for you, by hooking up the links you want to load content with javascript in designated page containers. Each webpage can have multiple page containers, each with a different set of pagination links. The page containers can be nested. Degrades gracefully when javascript is disabled.}

  s.rubyforge_project = "ajax_pagination"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "will_paginate"
  s.add_development_dependency "capybara"

  s.add_runtime_dependency "rails", '>= 3.1'
  s.add_runtime_dependency "jquery-rails", '>= 1.0.17' # require jQuery 1.7+
  s.add_runtime_dependency "jquery-historyjs"

end
