# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ajax_pagination/version"

Gem::Specification.new do |s|
  s.name        = "ajax_pagination"
  s.version     = AjaxPagination::VERSION
  s.authors     = ["Ronald Ping Man Chan"]
  s.email       = ["ronalchn@gmail.com"]
  s.homepage    = "https://github.com/ronalchn/ajax_pagination"
  s.summary     = %q{Handles AJAX site navigation, loads content into ajax_section containers using AJAX links.}
  s.description = %q{Loads page content into AJAX sections with AJAX links, handling the details for you, load content with javascript into designated page containers. Supports multiple and/or nested AJAX sections. Designed to be easy to use, customizable, supports browser history robustly, supports AJAX forms and has many more features. Degrades gracefully when javascript is disabled.}

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
  s.add_development_dependency 'ffi', '~> 1.0.11'
  s.add_development_dependency 'thor', '~> 0.14.4'
  s.add_development_dependency "capybara", '~> 1.1'
  s.add_development_dependency "rails", '~> 3.2'

  s.add_runtime_dependency "rails", '~> 3.0'
  s.add_runtime_dependency "jquery-rails", '>= 1.0.17' # require jQuery 1.7+
  s.add_runtime_dependency "jquery-historyjs"

end
