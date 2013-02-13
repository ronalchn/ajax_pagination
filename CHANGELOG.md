## v0.6.5
* Fixed release version

## v0.6.4
* Fix inputchangeselector bug (this feature still untested)
* Ensure ?ajax_section parameter in querystring (request.GET) - so as not to pollute POST or similar data.
* Timer in custom queue should revert URL, removing ajax_section parameter from link href attribute (action for forms), so that mouse hover shows original url in status bar
* Fixed build problems using newer versions of gems - particularly changes in Rack and Capybara
* UTF8 encoding fixed in URL
* Relicensed as MPL - reasoning is that I do not want to release as MIT or similar free license because of the potential for a fork to close the source. I also do not want to use GPL because it is too strong. LGPL was also a little iffy. MPL means that this gem can be easily used in any application, whether open or closed source, but keeps any modifications to this gem open source.

## v0.6.3
* Internal spec build changes
* ajax_pagination.js now requires other javascript dependencies, so developers no longer need to require dependencies as well in application manifest anymore (note, it can still be required - sprockets should ensure only 1 copy of each js file is included)

## v0.6.2
* Added :except and :only options to the ajax_respond class method (to specify actions which trigger responding to AJAX request)
* Converted ajax_section method to return symbol instead of string, and using symbols for both sections and actions internally (strings passed into methods will be converted into symbols)
* Rewrote ajax_respond class method to add default_render behaviour which checks for AJAX requests in a more efficient way
* Rename ajax_section_displayed? to ajax_section?, for brevity.

## v0.6.1
* The ajaxp:done event now sends an extra argument - the ajax_loadzone DOM element. This makes it easier for the event handler to make animations involving the loadzone. If it does not exist, null is returned.
* one set of internally used data-pagination attributes has been renamed to data-ajax_section_id.
* The ?pagination= querystring parameter has been renamed to ajax_section.
* Fixed Travis CI tests to start up WEBrick servers with the correct rails version.
* Removed deprecated options - from v0.6.0

## v0.6.0
The :pagination option no longer makes as much sense, now that the sections are called ajax_section. Also, this gem is as much about site navigation as pagination. This is the reason for some of the following changes.

* Further name changes made - :pagination option now called :section_id option in AJAX Pagination methods (with exception of ajax_section method), :pagination still works, but is now deprecated.

**It is suggested to grep :pagination and rename to :section_id**

* ajax_section :pagination option now called :id option, :pagination still works, but deprecated
* New :section_id, ajax_section :id options now defaults to "global" in all methods - this is backwards incompatible
* Added ajax_links helper method, to replace the magic container (a div container with class of ajaxpagination).
* div containers of class pagination are no longer magic containers
* Added ajax_section method in ActionController - which is set to the only section that should be displayed in an AJAX request. It is nil for normal requests.

**Avoid using data-pagination, or inspecting params[:pagination] directly. These will be changed in the next version. Instead, use the helper methods provided.**

## v0.5.1
* Added generator for assets (so asset pipeline is no longer required).
* Added tests for a Rails 3.0.x application.

## v0.5.0
This release has no new features, however, it is backwards incompatible because several methods have been renamed for clarity.

The new method names are ajax_respond in the controller instead of ajax_pagination, ajax_section in the view instead of ajax_pagination, ajax_loadzone instead of ajax_pagination_loadzone, and ajax_section_displayed? instead of ajax_pagination_displayed?.

Hopefully, the new names will make it easier to learn to use this gem, and is happening along with some slight changes in how various parts of the AJAX process is named.

I have for a while thought that the overloading of the same name ajax_pagination, with the name giving little clue as to its use, was confusing. However, it has taken a while to come up with a suitable replacement. Other name changes are simply to maintain the same naming format.

The minor version bump is for backwards incompatibility. Although there is little changed, this is a new minor version because I want to make a release with this new API earlier, before more people use the old interface.

## v0.4.0
* Reload logic rewritten, we now have world-class support for browser history. This is the biggest change. It is almost unnecessary to use the :reload option now, because the history support engine is much more intelligent. The original reason for the :reload option is to expose good history behaviour. This is now unnecessary, because the glitches which would otherwise occur are now solved in a better way. There is one remaining use for it. When browsers visit the same url, they do not add a new history item (therefore it is the same as clicking refresh). And when jumping to another history item with the same url, Firefox does not reload the page (although Chrome does). AJAX Pagination behaves like Firefox. However, sometimes different urls refer to the same content, when considering just a single section of the page. The :reload option is now used for this purpose. If present, it should specify all the important parts of the url which should be the same, for two different urls to be considered to same for the page section. The syntax for this reload specification is identical to before. Only the use of it has changed. Although this does change behaviour quite a bit, existing code should still work fine. This was changed because this behaviour more successfully mimics browser behaviour automatically - so less configuration.
* Moving css from javascript to stylesheet - this should make it easier to customize aspects of it.
* Expose a $.ajax_pagination API with a well-defined, and useful interface.
* Javascript enabled when AJAX loads full page. Only scripts inside of &lt;div&gt; section inserted will be executed.
* Fix bug: When javascript active but AJAX Pagination disabled, ajax_link_to, ajax_form_tag, ajax_form_for tags stop working because of data-remote. Now data-remote is tidied up so that jquery-ujs not activated (which is the cause of the bug).
* Make javascript more robust - rare bugs which occur for webpages with poor structuring of divs with class paginated_section.
* Added warnings page to example application to demonstrate possible warnings.
* Added events ajaxp:before, ajaxp:beforeSend, ajaxp:done, ajaxp:fail, ajaxp:loading, ajaxp:focus, ajaxp:loaded - these emit from section where page is loading (wheres ajax:? events emit from link clicked). New events also fire due to browser back/forward (while ajax:? only do not fire on browser back - these come from jquery-ujs)
* Visual cues overridable (by returning false from events).
* When jumping history, section no longer gets reloaded if parent already being reloaded.

## v0.3.0
* Class method ajax_pagination :reload option - a string in json form no longer accepted, pass it in as a hash or array of hashes instead
* image option added to ajax_pagination view helper, to specify a loading image other than the default
* For reloading of a page section on browser back/forward, urlregex urlparts option changed to parse the url in strict mode
* Fixed bug: The loading never stopped if page was invalid, it will now display the error page properly
* Fixed bug: back/forward not loading properly in certain cases
* AJAX Pagination now uses jquery-ujs! The internals have changed, but the released public API has not otherwise changed. However, this important change allows AJAX Pagination to handle links and forms requesting via POST, PUT and DELETE methods.
* Added link helper ajax_link_to, which wraps link_to. This helper is useful for one-off links to perform an AJAX call. In fact, the output link format that required to get AJAX Pagination to work.
* The original way to specify that links use AJAX Pagination - wrapping links within a container of ajaxpagination class, with data-pagination attribute is now a convenience feature provided, which actually uses javascript to set the same link attributes as the link helper.
* Added support for redirection - redirects are intercepted, and if they are AJAX calls with a pagination url parameter, will be modified into a Status 200 OK response with Location header. The AJAX call be manually follow the redirect, and update the url in the address bar. the pagination url parameter context can also be kept.
* Add support for changing page title in the returned AJAX partial which is better if using for site-wide navigation (before it simply preserved the previous title)
* Scrolling feature fixed, and a new configuration - scroll_margin provided
* Added form helpers which trigger ajax pagination
* Added ajax_options method, which can be used especially with form helpers from gems such as Formtastic or Simple Form.
* Added specs for new features (including displaying error pages, redirecting within div, submitting forms with PUT POST DELETE, testing ajax_link_to, ajax_form_tag, ajax_form_for (and with all these, indirectly testing ajax_options), title changes)

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

