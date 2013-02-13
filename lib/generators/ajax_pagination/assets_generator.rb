# Copyright (c) 2012 Ronald Ping Man Chan
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'rails'
require 'erb'

# Supply generator for Rails 3.0.x or if asset pipeline is not enabled
if true #::Rails.version < "3.1" || !::Rails.application.config.assets.enabled
  module AjaxPagination
    module Generators
      class AssetsGenerator < Rails::Generators::Base
        source_root File.expand_path("../../../../",__FILE__)

        desc "Fetches the ajax_pagination assets - javascript asset is processed based on current environment"

        def js
          jstemplate = ERB.new IO.read(File.expand_path("../../../assets/javascripts/ajax_pagination.js.erb",__FILE__))
          
          Dir.mkdir("public/javascripts") unless File.exists?("public/javascripts")

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

