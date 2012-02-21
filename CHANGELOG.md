## v0.1.1.alpha
* Fix jquery_rails dependency, requires jQuery 1.7+

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

