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

  # run rails generate ajax_pagination:install to create a default initializer with configuration values
  def self.config
    yield self
  end
end
