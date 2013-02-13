# Copyright (c) 2012 Ronald Ping Man Chan
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require "ajax_pagination/version"
require "ajax_pagination/controller_additions"
require "ajax_pagination/helper_additions"
require "ajax_pagination/rails"

module AjaxPagination
  # default loading image to use
  mattr_accessor :loading_image
  @@loading_image = "ajax-loader.gif"

  # whether javascript warnings are on, these present themselves as alerts
  mattr_accessor :warnings
  @@warnings = nil # if nil, uses default, which is true only in development mode

  # intercepts any AJAX Pagination 302 redirects, and turns them into Status 200 OK, with a Location: header. AJAX code can manually perform the redirection.
  # can be disabled in the initializer
  mattr_accessor :redirect_after_filter
  @@redirect_after_filter = true

  # when changing pages, AJAX Pagination scrolls to ensure the page sees the top of the changing section, plus an additional margin in pixels
  # to turn this feature off, set scroll_margin to '-Infinity'
  mattr_accessor :scroll_margin
  @@scroll_margin = 20

  # run rails generate ajax_pagination:install to create a default initializer with configuration values
  def self.config
    yield self
  end
end
