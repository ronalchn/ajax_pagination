require 'rails'
require 'erb'
require 'ftools'

# Supply generator for Rails 3.0.x or if asset pipeline is not enabled
if true #::Rails.version < "3.1" || !::Rails.application.config.assets.enabled
  module AjaxPagination
    module Generators
      class AssetsGenerator < Rails::Generators::Base
        source_root File.expand_path("../../../assets",__FILE__)

        desc "Fetches the ajax_pagination assets - javascript asset is processed based on current environment"

        def js
          jstemplate = ERB.new IO.read(File.expand_path("../../../assets/javascripts/ajax_pagination.js.erb",__FILE__))
          
          File.makedirs("public/javascripts/")
          create_file "public/javascripts/ajax_pagination.js", jstemplate.result(binding)
        end
        def css
          copy_file "stylesheets/ajax_pagination.css", "public/stylesheets/ajax_pagination.css"
        end

        private

        def asset_path(filename)
          "/images/" + filename
        end
      end
    end
  end
end

