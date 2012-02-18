# AJAX Pagination
**TO BE RELEASED**

Handles AJAX pagination for you, by hooking up the links you want to load content with javascript in designated page containers. Each webpage can have multiple page containers, each with a different set of pagination links. The page containers can be nested. Degrades gracefully when javascript is disabled.

## Introduction
This gem can ajaxify any pagination solution. Links wrapped in containers with specific classes will be ajaxified. This means that clicking it will instead send an AJAX request for the page in javascript format. The result will replace the content in a container for the content. this gem is tested to work for will_paginate, but should work for other pagination solutions, as well as navigation level links or tabbed interfaces. The ajax call will load new content into the designated content container.

## Background
This gem depends on Rails 3.1+, jQuery and jquery-historyjs. The gem was extracted from http://github.com/xrymbos/nztrain-v2/, and further development will be tied to the needs of the application. Therefore, some dependencies are because the application uses a particular version of these other gems. If you need to use this in other versions/javascript frameworks, I would welcome any pull requests. They are not currently supported because I do not need to use this gem in those other frameworks.

The original AJAX pagination functionality was inspired by the RailsCasts on pagination with AJAX. However, other functionality was added to the pagination, add more modular code was desired, especially when many different controllers need pagination.

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

## Getting started

The pagination needs a name (in case you have multiple sets of AJAX pagination on the same webpage). By default, the name is "page". If you only intend to use a single set of pagination links, then leave it as "page".

Move the content to be paginated into a partial. If you are using the will_paginate gem (or similar), there is only one set of content to put into a partial. If you are using this to paginate between distinct views or even different controllers, you will need to move each set of content into a different partial.

By default, AJAX Pagination looks for the pagination content in the partial with filename matching the name of the pagination (by default "page"), so it is a good idea to use this name. If multiple views have pagination content in the same controller (especially if for the same pagination set), you will need to use different filenames for them.

Then, instead of the paginated content, put the following in your view:

```ruby
<%= ajax_pagination %>
```

If the pagination name is not "page", pass the new pagination name in.

```ruby
<%= ajax_pagination :pagination => "page" %>
```

If the partial is not named the same, pass it the new name as an option:

```ruby
<%= ajax_pagination :partial => "mypartial" %>
```

This will case it to display content in the _mypartial.* view.

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

Now, AJAX pagination will automatically call the controller for new content when an ajaxified link is clicked.

However, the controller needs to be told how to respond. Add a call to ajax_pagination(format) in the controller action, which will return javascript containing the partial.

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

AJAX Pagination can also add a loading image and partially blanking out of the paginated content. To do this, wrap all the content you want to cover with ajax_pagination_loadzone. For example, in the partial, you might have:

```erb
<%= will_paginate @objects, :params => { :pagination => nil } %>
<%= ajax_pagination_loadzone do %>
  All content here is convered by a semi-transparent white rectangle, a loading image is displayed on top, and any links here are unclickable
<% end %>
```

Links outside are still clickable (such as the will_paginate links).

The loading image is currently an image asset at "ajax-loader.gif", so put your loading image there. (TODO: add default loader image, and make the location changeable)

## Javascript Dependency
As well as the included ajax_pagination.js file, 

## Development
You are welcome to submit pull requests on GitHub at https://github.com/ronalchn/ajax_pagination, however, please be aware that submitting a pull request is assumed to grant non-exclusive, perpetual rights to the use of the software for any use whatsoever. This allows me to release the software under a more permissible license in the future if I want.

If you do not submit a pull request, your modifications will not be merged into the codebase.

## License
Copyright © 2012 Ronald Ping Man Chan
If you want to use this program under a different license, please contact me.
All pull requests to my repository will be assumed to assign non-exclusive rights for perpertual usage for any use whatsoever for those modifications to Ronald Ping Man Chan. If you do not have the power to assign that right, do not submit a pull request. This allows me to release the software under a more permissible license in the future if I want.
Ronald

The software is released under LGPL. The LGPL License on this software means that this Gem can be used in any software (proprietary or otherwise), by using the gem command. However, the gem cannot be included directly in proprietary software (eg. as a plugin), without distributions of the software being under LGPL. Distribution of this Gem must be released under the LGPL as well.
