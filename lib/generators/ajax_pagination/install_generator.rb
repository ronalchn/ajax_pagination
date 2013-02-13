# Copyright (c) 2012 Ronald Ping Man Chan
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

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
