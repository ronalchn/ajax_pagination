# AJAX Pagination
[![Build Status](https://secure.travis-ci.org/ronalchn/ajax_pagination.png?branch=master)](http://travis-ci.org/ronalchn/ajax_pagination)

Handles AJAX pagination for you, by hooking up the links you want to load content with javascript in designated page containers. Each webpage can have multiple page containers, each with a different set of pagination links. The page containers can be nested. Degrades gracefully when javascript is disabled.

**Notice:** The current roadmap for the next version is tighter integration with jquery_ujs. Instead of creating ajax events directly through jquery, it is planned to get jquery_ujs to handle it as a remote request, and modify its behaviour through the jquery_ujs callbacks. This should not alter the usage of this gem (except for unreleased features).

## Introduction
This gem can ajaxify any pagination solution. Links wrapped in containers with specific classes will be ajaxified. This means that clicking it will instead send an AJAX request for the page. The result will replace the content in a container for the content. this gem is tested to work with will_paginate, but should work for other pagination solutions, as well as navigation level links or tabbed interfaces. The ajax call will load new content into the designated content container.

Please note, this is not a pagination solution by itself. You should use a pagination solution such as will_paginate and Kaminari, or a menu builder such as Simple-navigation or Semantic-menu, or you can roll your own. After that is implemented, you can use AJAX Pagination to ajaxify it, so that when users change pages, they do not have the reload the whole page.

AJAX Pagination is a powerful AJAX solution which is designed to be easy to use. You can add AJAX requests to your application, without touching a single line of javascript, because AJAX Pagination does it all for you. This gem follows the convention over configuration mantra. Therefore, the most common use cases will be much easier to implement. Users can progressively change the configuration as their use case differs from the norm. It is recommended to follow the convention unless it is necessary to do otherwise.

## Background
This gem depends on Rails 3.1+, jQuery and jquery-historyjs. The gem was extracted from http://github.com/xrymbos/nztrain-v2/, and further development will be tied to the needs of the application. Therefore, some dependencies are because the application uses a particular version of these other gems. If you need to use this in other versions/javascript frameworks, I would welcome any pull requests. They are not currently supported because I do not need to use this gem in those other frameworks.

The original AJAX pagination functionality was inspired by the RailsCasts on pagination with AJAX. However, other functionality was added to the pagination, and more modular code was desired, especially when many different controllers need pagination. Added functionality includes loading cues and support of multiple pagination areas on the same webpage.

Because the code became more modular, it also made it suitable to turn into a Ruby Gem, so that others can create AJAX pagination without fiddling with the details.

Rails 3.1+ is required only because the javascript is placed into the assets pipeline.

## Installation
Add to your Gemfile:

    gem 'ajax_pagination'

and run the bundle install command.

Then add to your assets/javascripts/application.js,

```javascript
//= require ajax_pagination
```

AJAX Pagination depends on jquery-rails and jquery-historyjs, so if their javascript files are not already included, also include to following in your assets/javascripts/application.js file:

```javascript
//= require jquery
//= require history
```

## Getting Started
The next section presents the usage of the functions in detail. However, it also presents the different options that can be chosen. For a simpler overview of how you can easily use this gem, please read one of the more specific guides below (found in the wiki):

* [Add AJAX to will_paginate](https://github.com/ronalchn/ajax_pagination/wiki/Adding-AJAX-to-will_paginate)
* [Add AJAX to site navigation](https://github.com/ronalchn/ajax_pagination/wiki/Adding-AJAX-to-site-navigation)

and much [more](https://github.com/ronalchn/ajax_pagination/wiki/Home).

## Usage

The pagination needs a name (in case you have multiple sets of AJAX pagination on the same webpage). By default, the name is "page". If you only intend to use a single set of pagination links, then leave it as "page". The name is used to distinguish different sets of pagination links, and is also used as a default for other functionaility.

### Ajaxifying the content

Move the content to be paginated into a partial. If you are using the will_paginate gem (or similar), there is only one set of content to put into a partial. If you are using this to paginate between distinct views or even different controllers, you will need to move each set of content into a different partial.

By default, AJAX Pagination looks for the pagination content in the partial with filename matching the name of the pagination (by default "page"), so it is a good idea to use this name. If multiple views have pagination content in the same controller (especially if for the same pagination set), you will need to use different filenames for them.

Then, instead of the paginated content, put the following in your view:

```erb
<%= ajax_pagination %>
```

If the pagination name is not "page", pass the new pagination name in.

```erb
<%= ajax_pagination :pagination => "page" %>
```

If the partial is not named the same, pass it the new name as an option:

```erb
<%= ajax_pagination :render => "mypartial" %>
```

This will cause it to display content in the _mypartial.* view.

If you are using will_paginate, and the links are wrapped in a div with class="pagination", the links will be ajaxified automatically.

Otherwise, you should wrap the links with a container. We recommend that the class given is "ajaxpagination". You can put the links inside the partial, for example:

```html
<div class="ajaxpagination"><a href="#">My ajaxified link</a></div>
```

If you are using will_paginate, you can simply put the links inside the partial (so that the new links get reloaded when the page changes):

```erb
<%= will_paginate @objects, :params => { :pagination => nil } %>
```

Note: It is recommended to set the pagination parameter to nil. When AJAX pagination calls the controller with a request for the partial, it appends ?pagination=NAMEOFPAGINATION. If the parameter is not set, AJAX Pagination will not respond to the AJAX call. will_paginate by default keeps any parameters in the query string. However, because this parameter is for internal use only, setting it to nil will keep the parameter from showing up in the url, making it look nicer (also better for caching).

Now, AJAX Pagination will automatically call the controller for new content when an ajaxified link is clicked.

If the links are outside the partial, you will need to also let AJAX Pagination know what content container should be reloaded when the links are followed. In this case, the div with ajaxpagination class should define the data-pagination attribute, the value corresponding to the name of the pagination content, for example you can do the following (which ajaxifies the menu navigation links):

```erb
<div class="ajaxpagination menu" data-pagination="menu">
  <ul>
    <li><%= link_to "Home", root_url %></li>
    <li><%= link_to "Posts", posts_url %></li>
    <li><%= link_to "Changelog", changelog_url %></li>
    <li><%= link_to "Readme", pages_readme_url %></li>
    <li><%= link_to "About", pages_about_url %></li>
  </ul>
</div>
<%= ajax_pagination :pagination => "menu", :reload => {:urlpart => "path", :urlregex => "^.*$"} do %>
  <%= yield %>
<% end %>
```

Incidentally, this example also presents an alternative to passing in a :render option to <tt>ajax_pagination</tt>. Instead, you can pass it a block, in which case you can call the render helper yourself, or any other function (in this case, yield). If a block is passed, any :render option is ignored.

### Controller responder

However, the controller needs to be told how to respond. If we do not indicate the response, it will render the whole html page as usual. This will still work (and only display the new content required), but it will send all the page content. By default, when this happens in development, an alert will pop up warning that this is not the best solution. AJAX Pagination works around this by detecting that you want to load new content into a section called "page" for example, but the new content actually contains a section called "page". Therefore, it replaces the old content with only the content of the response inside the section "page".

This behaviour makes it easy to get AJAX Pagination working. And if you are not worried about efficiency (sending all the page content all the time), or if you are doing this for page caching purposes, you can leave it as is. To turn off the warning in development mode, simply generate an initializer, and set ```ruby
config.warnings = false
```.

To only send the data that is required (not including the page layout etc.), add a call to <tt>ajax_pagination(format)</tt> in the controller action.

```ruby
respond_to do |format|
  format.html # index.html.erb
  ajax_pagination(format)
end
```

If either the pagination name or the partial filename is not the default (a partial named whatever :pagination is, "_page" in this case), you will need to pass these in as options.

```ruby
ajax_pagination format, :pagination => "page", :render => "mytemplate"
```

This will render controller/mytemplate. If you want a partial to be rendered, use:

```ruby
ajax_pagination format, :pagination => "page", :render => {:partial => "mytemplate"}
```

In both cases, the layout is off by default. You can pass in a layout to use in the render by the usual means.

The pagination should now be more efficient.

### Default controller responder

Although it is fine if used for a single action, eg. with will_paginate, individually adding a respond_to line for every controller and action might take a while, if used for site navigation, or navigating between the different actions of a single controller.

There is also a class method defined for ActionController, also named ajax_pagination. If we are using it for site navigation, and the pagination name is "menu", then we can simply call:

```ruby
class ApplicationController < ActionController:Base
  ajax_pagination :pagination => "menu"
end
```

We can, as with the instance method, also pass in a ```ruby
:render => { :template => "myview", :layout => "mylayout" }
``` option. However, in this case, it is actually designed to be used without specifying the view template displayed. The reason is that when it is not defined, the default behaviour is normally what you want. Suppose you accessed a page at the url /controller/action?pagination=menu. The pagination=menu query argument indicates that this is a special AJAX request. If pagination is not defined exactly as "menu" in this example, the rendering does not trigger.

AJAX Pagination first tries to render "controller/_menu", :layout => false, if it exists. If it does not, then it will render "controller/action", :layout => false.

Therefore, when used for site navigation, it will by default, render the same page it would otherwise have rendered, only without the layout. Sometimes, we have parts of the page we want to render again (and is wrapped by the ajax_pagination container which identifies the section of the page which is reloaded), but exists in the layout. To deal with this case, we can set the layout to a special layout. This is used if, for example, we have flash notices or alerts we want to be removed, or displayed as appropriate for each AJAX call.

In this case, we create a layout in layouts/flash_layout.html.erb for example, which renders the flash notices. Then, we can pass the layout in as follows:

```ruby
class ApplicationController < ActionController:Base
  ajax_pagination :pagination => "menu", :render => { :layout => "flash_layout" }
end
```

Notice that no template file is specified. By not specifying the view template file, the controller/action view will be rendered.

If we want to navigate within a controller, we can use this in the specific controller instead of the ApplicationController.

Please note that the class method only specifies the default behaviour, by defining default_render (but it only triggers on the AJAX calls, otherwise it calls the original default_render function to handle the rendering). This default can be overrided by calling the instance method within an action, allowing you to use this for special cases (controllers or actions).

Because the default_render method is used, if you subsequently define default_render, you may clobber the behaviour defined by AJAX Pagination. To deal with this, make sure that the call to the ajax_pagination class method is after any other definition. AJAX Pagination will not clobber any default_render method already defined. Requests which are not AJAX calls will be passed on to the original default_render method.

### Loading visualization

AJAX Pagination can also add a loading image and partially blanking out of the paginated content. To do this, you can wrap all the content you want to cover with <tt>ajax_pagination_loadzone</tt>. For example, in the partial, you might have:

```erb
<%= will_paginate @objects, :params => { :pagination => nil } %>
<%= ajax_pagination_loadzone do %>
  While this partial is being loaded with other content,
  all content here has opacity reduced, and is covered by a transparent rectangle,
  a loading image is displayed on top, and any links here are unclickable
<% end %>
```

Links outside are still clickable (such as the will_paginate links).

The loading image is currently an image asset at "ajax-loader.gif", so put your loading image there. You can specify a new default filename in your initializer. If you want a different loading image (other than configuring a site-wide default), you can pass an option :image => "newimageinassetpipeline.gif" to the ajax_pagination view helper method.

If you want all the content in the partial (or otherwise wrapped by the ajax_pagination helper method) to be included as a loading zone (with the visual loading cues), you can instead, set the :loadzone option to true, eg:

```erb
<%= ajax_pagination :pagination => "menu", :reload => {:urlpart => "path", :urlregex => "^.*$"}, :loadzone => true do %>
  <%= yield %>
<% end %>
```

In this case, whatever is inside the yield will not need to call ajax_pagination_loadzone.

### Content reloading

The back and forward buttons on your browser may not work properly yet. It will work as long as the link includes distinct query parameter with the same name as the pagination name for the set. For example, if the name of the pagination set is "page" (the default), when the browser url changes, AJAX Pagination looks for a change in the links query parameter with the same name, such as if the url changes from /path/to/controller?page=4 to /path/to/controller?page=9, then AJAX Pagination knows that the content corresponding to the pagination set needs reloading. The absence of the parameter is a distinct state, so changes such as /path/to/controller to /path/to/controller?page=0 are detected.

However, if the pagination is to different controllers, eg. url changes from /ControllerA to /ControllerB, AJAX Pagination will not reload the content, because the name of the pagination set is "page", and the url ?page=... parameter has not changed. There are some options that can be passed to ajax_pagination, through the reload option.

```erb
<%= ajax_pagination :reload => {:query => "watching"} %>
```

By passing reload a hash, mapping query to watching, AJAX Pagination will reload the content if the query parameter named "watching" changes. For example, if the url changes from ?watching=A to ?watching=B.

For more flexibility, a regular expression can be passed like so:

```erb
<%= ajax_pagination :reload => {:urlregex => "page=([0-9]+)", :regexindex => 1} %>
```

Which applies the regex expression /page=([0-9]+)/ to the url. The parameter regexindex then selects the nth matching subexpression, on which changes are detected. The subexpression indexed 0 is the complete match. The subexpression index 1 is the page number in this case. So when that changes, the page is reloaded.

For more flexibility, a number of conditions can be passed in an array. If any of them change, the content is reloaded.

```erb
<%= ajax_pagination :reload => [{:urlregex => "page=([0-9]+)", :regexindex => 1},{:query => "watching"}] %>
```

### Initializer
You can configure AJAX Pagination in the initializer. Run ```
rails generate ajax_pagination:install
``` to get the initializer file.

## Example Application
This gem contains an example application (actually, it is there also for testing purposes), however it is nevertheless a good example.

Clone this repository, and run the server, using:

```sh
git clone git://github.com/ronalchn/ajax_pagination.git
cd ajax_pagination
cd spec/rails_app
bundle install
bundle exec rails server
```

Then point your browser to http://localhost:3000/

## AJAX Call
The AJAX Call is triggered by a link wrapped in any container with a certain class. The AJAX Call is to the same address, but with the ?pagination=NAME parameter added. The format requested is javascript. If the controller also returns javascript for other uses, AJAX Pagination does not necessarily prevent such uses. The ajax_pagination(format, :pagination => "page") function in the controller handles the AJAX Call when the format is javascript, and the ?pagination parameter is set to the correct string. It also returns true if the pagination parameter matches. Therefore, you can use use the javascript format when it does not match, as shown below:

```ruby
respond_to do |format|
  format.html # index.html.erb
  format.js unless ajax_pagination(format)
end
```

Note that **unless** does not need to be used, since respond_to is actually sensitive to the ordering, so an equivalent effect is achieved with:

```ruby
respond_to do |format|
  format.html # index.html.erb
  ajax_pagination(format)
  format.js # index.js.erb
end
```

## Javascript Dependency
As well as the included ajax_pagination.js file, this gem uses jquery.ba-bbq.js and jquery.url.js, which are jquery plugins. They are included in the gem as assets already to simplify installation. ajax_pagination.js will automatically require jquery.ba-bbq.js, and jquery.url.js.

However, if you are already using them (especially if using a different version), simply ensure that your assets directory contains javascript files of the same name to shadow/override the file in the gem.

The other javascript dependencies rely on gems: jquery-rails, and jquery-historyjs. So if they are used, AJAX Pagination should play well with other gems using the libraries.

## Development
You are welcome to submit pull requests on GitHub at https://github.com/ronalchn/ajax_pagination, however, please be aware that submitting a pull request is assumed to grant to me non-exclusive, perpetual rights to the use of the software for any use whatsoever. This allows me to release the software under a more permissible license in the future if I want.

If you do not submit a pull request, your modifications will not be merged into the codebase.

## License
Copyright © 2012 Ronald Ping Man Chan

If you want to use this program under a different license, please contact me.
All pull requests to my repository will be assumed to assign to me non-exclusive rights for perpertual usage for any use whatsoever for those modifications to Ronald Ping Man Chan. If you do not have the power to assign that right, do not submit a pull request. This allows me to release the software under a more permissible license in the future if I want.
Ronald

The software is released under LGPL. The LGPL License on this software means that this Gem can be used in any software (proprietary or otherwise), by using the gem command. However, the gem cannot be included directly in proprietary software (eg. as a plugin), without distributions of the software being under LGPL. Distribution of this Gem must be released under the LGPL as well.
