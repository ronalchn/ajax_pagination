## v0.2.0.alpha
* Fix jquery_rails dependency, requires jQuery 1.7+
* rename :partial option to :render in controller_additions methods (all instance and class methods added to ActionController). This is because it now has behaviour like the ActionController render function rather than the ActionView render function
* change AJAX requests from js to html format. The motivation is to lower barrier to entry, getting AJAX to work. Now, no actual ajax_pagination instance method need be called in the controllers. It is less efficient, and normally not recommended, but not calling it will result in the default template (full page including application layout) to be returned in the AJAX call. AJAX Pagination can then pick out the paginated section required (throwing away everything else).
* added class method to ActionController which can add AJAX Pagination behaviour to the default_render method. This can be called at the ApplicationController level or for a specific controller. However, this is probably most useful at the application level for AJAX menu navigation (so that ajax_pagination does not need to be called in each controller/action)
* Warnings added when AJAX Pagination cannot complete AJAX action, or when the setup is suboptimal. This is on only in development mode by default (see gem initializer). These warnings appear as alerts, and are displayed by the javascript code.
* Initializer generator added, with configuration for an alternative loading image, and warnings setting.
* Note readme needs to be updated with new API still, use rdoc to get latest api until this version is released.

## v0.1.0
* Added functional tests for controller and helper additions.
* Mocked up a rails application using ajax_pagination, at spec/rails_app/. You can run this example application using:

```sh
bundle install
bundle exec rails server
```

* Added more mock changelog model and controller (including various dummy informational pages) to test application.
* Modified controller and helper additions, so that they are more suitable for ajaxifying menu navigations.
* Added loadzone option to the ajax_pagination helper, so that ajax_pagination_loadzone does not need to be used.
* Modularised javascript further so only a single function is globally accessible through the jQuery object.
* Example application shows nested AJAX pagination, and multiple AJAX paginated sections in one page.
* Default loading image added to gem.
* urlregex parameter on the reload option extended with urlpart, to make it easier to specify a regular expression on only part of the url. Gem now depends on jquery.url.js as well (vendorized automatically, same as with the jquery.ba-bbq.js dependency).
* Added some RSpec tests on example application with and without javascript
* Make rake travis task for easy testing (automatically starts up daemonized webrick server for selenium tests, also cleans up the daemon). The test script will clone the development database to create a test database. There is a bundling problem with the external javascript dependencies (those inside other gems), so the script also copies the javascript files into a local vendor/assets/javascripts directory (keeping them up-to-date).

## v0.0.2
* Semi-transparent white rectangle changed to completely transparent rectangle. Instead, the opacity of the content behind it is lowered to achieve the same effect, but works better on backgrounds of other colours as well.
* Added rdoc comments to code
* README updated

## v0.0.1

* initial release.

