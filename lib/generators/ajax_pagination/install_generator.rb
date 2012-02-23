module AjaxPagination
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates",__FILE__)

      desc "Creates a Ajax Pagination initializer"

      def initializer
        template "ajax_pagination.rb", "config/initializers/ajax_pagination.rb"
      end
    end
  end
end
