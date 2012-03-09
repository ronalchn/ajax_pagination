require 'rails'
require 'erb'
if (RUBY_VERSION.split('.').collect(&:to_i) <=> [1,9]) == -1
  require 'ftools'
  MKDIRSNAME = 'ftools'
else
  require 'fileutils'
  MKDIRSNAME = 'fileutils'
end

# Supply generator for Rails 3.0.x or if asset pipeline is not enabled
if true #::Rails.version < "3.1" || !::Rails.application.config.assets.enabled
  module AjaxPagination
    module Generators
      class AssetsGenerator < Rails::Generators::Base
        source_root File.expand_path("../../../../",__FILE__)

        desc "Fetches the ajax_pagination assets - javascript asset is processed based on current environment"

        def js
          jstemplate = ERB.new IO.read(File.expand_path("../../../assets/javascripts/ajax_pagination.js.erb",__FILE__))
          
          File.makedirs("public/javascripts/") if MKDIRSNAME == 'ftools'
          FileUtils.makedirs("public/javascripts/") if MKDIRSNAME == 'fileutils'
          create_file "public/javascripts/ajax_pagination.js", jstemplate.result(binding)
          copy_file "vendor/assets/javascripts/jquery.ba-bbq.js", "public/javascripts/jquery.ba-bbq.js"
          copy_file "vendor/assets/javascripts/jquery.url.js", "public/javascripts/jquery.url.js"
        end
        def css
          copy_file "lib/assets/stylesheets/ajax_pagination.css", "public/stylesheets/ajax_pagination.css"
        end
        def img
          copy_file "lib/assets/images/ajax-loader.gif", "public/images/ajax-loader.gif"
        end
        private

        def asset_path(filename)
          "/images/" + filename
        end
      end
    end
  end
end

