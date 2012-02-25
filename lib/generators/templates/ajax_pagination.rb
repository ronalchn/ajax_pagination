AjaxPagination.config do |config|
  # uncomment to change default loading image file, located in assets/images.
  # config.loading_image = "ajax-loader.gif"

  # whether javascript warnings are on, these present themselves as alerts
  # by default, warnings are active only if the environment is development
  # to configure by environment otherwise, this configuration needs to be added to the environment specific files
  # uncomment to turn warnings on in all environments
  # config.warnings = true
  # or to turn off in all environments
  # config.warnings = false

  # Intercepts 302 redirects, if the request is an AJAX call with a ?pagination= parameter in the GET url
  # This is used because browsers transparently follow 302 redirects, without the AJAX javascript code being aware
  # that a redirection has taken place. The response is changed into a Status 200 OK, with an extra Location: header
  # The javascript code can then manually follow the redirect, and perform the necessary cleanup tasks (change the url
  # in the address bar). The default is on (true), use the following line to disable it if desired. If disabled, it can
  # be re-enabled in specific controllers by adding after_filter :ajax_pagination_redirect to the class.
  # config.redirect_after_filter = true

  # when changing pages, AJAX Pagination scrolls to ensure the page sees the top of the changing section, plus an additional margin in pixels
  # The default margin is 20 pixels, as set by the line below
  # config.scroll_margin = 20
  # To disable auto-scrolling, uncomment the line below
  # config.scroll_margin = '-Infinity'
end
