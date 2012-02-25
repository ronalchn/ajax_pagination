## v0.3.0 **TO BE RELEASED**
* Class method ajax_pagination :reload option - a string in json form no longer accepted, pass it in as a hash or array of hashes instead
* image option added to ajax_pagination view helper, to specify a loading image other than the default
* For reloading of a page section on browser back/forward, urlregex urlparts option changed to parse the url in strict mode
* Fixed bug: The loading never stopped if page was invalid, it will now display the error page properly
* Fixed bug: back/forward not loading properly in certain cases
* AJAX Pagination now uses jquery-ujs! The internals have changed, but the released public API has not otherwise changed. However, this important change allows AJAX Pagination to handle links and forms requesting via POST, PUT and DELETE methods.
* Added link helper ajax_link_to, which wraps link_to. This helper is useful for one-off links to perform an AJAX call. In fact, the output link format that required to get AJAX Pagination to work.
* The original way to specify that links use AJAX Pagination - wrapping links within a container of ajaxpagination class, with data-pagination attribute is a convenience feature provided, which actually uses javascript to set the same link attributes as the link helper.
* Added support for redirection - redirects are intercepted, and if they are AJAX calls with a pagination url parameter, will be modified into a Status 200 OK response with Location header. The AJAX call be manually follow the redirect, and update the url in the address bar. the pagination url parameter context can also be kept.
* Add support for changing page title in the returned AJAX partial which is better if using for site-wide navigation (before it simply preserved the previous title)
* Scrolling feature fixed, and a new configuration - scroll_margin provided
* Added form helpers which trigger ajax pagination
* Added ajax_options method, which can be used especially with form helpers from gems such as Formtastic or Simple Form.

* TODO: add specs for new features

## v0.2.0
**Note: The API has changed slightly from previous versions. If you have used an advanced feature - the :partial option, please use :render now, and if used in a controller, a non-partial template will be used. To use a partial, specify :render => { :partial => "" }.**

* Fix jquery_rails dependency, requires jQuery 1.7+
* rename :partial option to :render in controller_additions methods (all instance and class methods added to ActionController). This is because it now has behaviour like the ActionController render function rather than the ActionView render function
* change AJAX requests from js to html format. The motivation is to lower barrier to entry, getting AJAX to work. Now, no actual ajax_pagination instance method need be called in the controllers. It is less efficient, and normally not recommended, but not calling it will result in the default template (full page including application layout) to be returned in the AJAX call. AJAX Pagination can then pick out the paginated section required (throwing away everything else).
* removed all publicly accessible javascript function, there was 1 accessible function for the AJAX result, but it has been removed in favour of the jQuery callback
* added class method to ActionController which can add AJAX Pagination behaviour to the default_render method. This can be called at the ApplicationController level or for a specific controller. However, this is probably most useful at the application level for AJAX menu navigation (so that ajax_pagination does not need to be called in each controller/action)
* Warnings added when AJAX Pagination cannot complete AJAX action, or when the setup is suboptimal. This is on only in development mode by default (see gem initializer). These warnings appear as alerts, and are displayed by the javascript code.
* Initializer generator added, with configuration for an alternative loading image, and warnings setting.
* renamed data-reload to data-pagination. The new attribute name is already used, but in different circumstances. Note this attribute is only set internally, so usage has not changed. This change should minimise the footprint of AJAX Pagination.
* updated readme

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

