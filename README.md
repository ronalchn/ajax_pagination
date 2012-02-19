# AJAX Pagination

Handles AJAX pagination for you, by hooking up the links you want to load content with javascript in designated page containers. Each webpage can have multiple page containers, each with a different set of pagination links. The page containers can be nested. Degrades gracefully when javascript is disabled.

## Introduction
This gem can ajaxify any pagination solution. Links wrapped in containers with specific classes will be ajaxified. This means that clicking it will instead send an AJAX request for the page in javascript format. The result will replace the content in a container for the content. this gem is tested to work with will_paginate, but should work for other pagination solutions, as well as navigation level links or tabbed interfaces. The ajax call will load new content into the designated content container.

Please note, this is not a pagination solution by itself. You should use a pagination solution such as will_paginate and Kaminari, or a menu builder such as Simple-navigation or Semantic-menu, or you can roll your own. After that is implemented, you can use AJAX Pagination to ajaxify it, so that when users change pages, they do not have the reload the whole page.

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

## Getting started

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
<%= ajax_pagination :partial => "mypartial" %>
```

This will cause it to display content in the _mypartial.* view.

If you are using will_paginate, and the links are wrapped in a div with class="pagination", the links will be ajaxified automatically.

Otherwise, you should wrap the links with a container. We recommend that the class given is "ajaxpagination". For example:

```html
<div class="ajaxpagination"><a href="#">My ajaxified link</a></div>
```

If you are using will_paginate, you can simply put this in the partial (so that the new links get reloaded when the page changes):

```erb
<%= will_paginate @objects, :params => { :pagination => nil } %>
```

Note: It is recommended to set the pagination parameter to nil. When AJAX pagination calls the controller with a request for the partial, it appends ?pagination=NAMEOFPAGINATION. If the parameter is not set, AJAX Pagination will not respond to the AJAX call. will_paginate by default keeps any parameters in the query string. However, because this parameter is for internal use only, setting it to nil will keep the parameter from showing up in the url, making it look nicer (also better for caching).

Now, AJAX Pagination will automatically call the controller for new content when an ajaxified link is clicked.

### Controller responder

However, the controller needs to be told how to respond. Add a call to <tt>ajax_pagination(format)</tt> in the controller action, which will return javascript containing the partial.

```ruby
respond_to do |format|
  format.html # index.html.erb
  ajax_pagination(format)
end
```

If either the pagination name or the partial filename is not the default, you will need to pass these in as options.

```ruby
ajax_pagination format, :pagination => "page", :partial => "mypartial"
```

The pagination should now work.

### Loading visualization

AJAX Pagination can also add a loading image and partially blanking out of the paginated content. To do this, wrap all the content you want to cover with <tt>ajax_pagination_loadzone</tt>. For example, in the partial, you might have:

```erb
<%= will_paginate @objects, :params => { :pagination => nil } %>
<%= ajax_pagination_loadzone do %>
  While this partial is being loaded with other content,
  all content here has opacity reduced, and is covered by a transparent rectangle,
  a loading image is displayed on top, and any links here are unclickable
<% end %>
```

Links outside are still clickable (such as the will_paginate links).

The loading image is currently an image asset at "ajax-loader.gif", so put your loading image there. (TODO: add default loader image, and make the location changeable)

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

Instead of passing in the Array/Hash Ruby object, a string in json form is accepted:

```erb
<%= ajax_pagination :reload => '[{"urlregex":"page=([0-9]+)","regexindex":1},{"query":"page"}]' %>
```
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
As well as the included ajax_pagination.js file, this gem uses jquery.ba-bbq.js, a jquery plugin. This is included in the gem as an asset already to simplify installation. ajax_pagination.js will automatically require jquery.ba-bbq.js.

However, if you are already using this (especially a different version of this), simply ensure that your file is named jquery.ba-bbq.js as well, so that it overrides the file in the gem.

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
