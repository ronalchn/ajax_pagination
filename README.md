# AJAX Pagination
[![Build Status](https://secure.travis-ci.org/ronalchn/ajax_pagination.png?branch=master)](http://travis-ci.org/ronalchn/ajax_pagination)

[Wiki](https://github.com/ronalchn/ajax_pagination/wiki) | [RDoc](http://rdoc.info/gems/ajax_pagination/frames) | [Changelog](https://github.com/ronalchn/ajax_pagination/blob/master/CHANGELOG.md)

Loads page content into AJAX sections with AJAX links, handling the details for you, load content with javascript into designated page containers. Supports multiple and/or nested AJAX sections. Designed to be easy to use, customizable, supports browser history robustly, supports AJAX forms and has many more features. Degrades gracefully when javascript is disabled.

Each webpage can have multiple ajax_section containers, whether they are side by side, or even nested. Links can reference an ajax_section to load new content into the section using AJAX. Watch as the URL in the browser address bar updates, with fully working back/forward buttons.

For more, see [Introduction and Background](https://github.com/ronalchn/ajax_pagination/wiki/Introduction-and-Background).

This gem requires Rails 3.0+. When using the asset pipeline in Rails 3.1+, follow the general installation instructions. Otherwise, use the ajax_pagination:assets generator, which puts the assets into the public/ directory.

## Demonstration Video
<table>
    <tr>
        <td width="176">
          <a href="http://ronalchn.github.com/ajax_pagination/"><img src="http://ronalchn.github.com/ajax_pagination/videos/ajaxpaginationdemo.gif" width="176" height="120"></a>
        </td>
        <td valign="top">
          To see this gem in action, watch the <a href="http://ronalchn.github.com/ajax_pagination/">demonstration video</a>, as shown left. It shows a built-in animation on loading, fully working history and AJAX requests which can perform POST and DELETE requests, whether via a link or a form submission and redirects.
        </td>
    </tr>
</table>


## Installation
Assuming, you are using the asset pipeline, add to your Gemfile:

    gem 'ajax_pagination'

and run the bundle install command.

Then add ajax_pagination to your asset manifests,

```js
// app/assets/javascripts/application.js
//= require ajax_pagination
```

```css
/* app/assets/stylesheets/application.css
 *= require ajax_pagination
 */
```

To use this on Rails 3.0, or without using the asset pipeline, read the [Installation without the Asset Pipeline](https://github.com/ronalchn/ajax_pagination/wiki/Installing-without-the-Asset-Pipeline) guide.

## Basic Usage
In the ActionView, use ajax_section to declare a section, and ajax_link_to to create a link loading content into the section:

```erb
<%= ajax_link_to "Link", link_url, :section_id => "section_name" %>
<%= ajax_section :id => "section_name", :render => "mypartial" %>
```

Then, in the ActionController, use ajax_respond to render only the partial when an AJAX request is made:

```ruby
Class ObjectsController < ApplicationController
  def index
    ...
    respond_to do |format|
      format.html # index.html.erb
      ajax_respond format, :section_id => "section_name", :render => "_mypartial"
    end
  end
  ...
end
```

Much more information can be found in the wiki.

## Getting Started
To learn how to use this gem, read one of the usage guides below (found in the wiki):

* [Adding AJAX to will_paginate](https://github.com/ronalchn/ajax_pagination/wiki/Adding-AJAX-to-will_paginate)
* [Adding AJAX to site navigation](https://github.com/ronalchn/ajax_pagination/wiki/Adding-AJAX-to-site-navigation)

For more, including how specific features work, look in the [wiki](https://github.com/ronalchn/ajax_pagination/wiki/Home).

Alternatively, to see the API, see [RDoc](http://rdoc.info/gems/ajax_pagination/frames).

## Features

* So easy to use, you don&#39;t need to touch a single line of javascript
* Supports multiple and nested sections
* Supports browser history, for more see [Robust Support for Browser History in AJAX Pagination](https://github.com/ronalchn/ajax_pagination/wiki/Robust-Support-for-Browser-History-in-AJAX-Pagination)
* Supports links, but also POST, DELETE, PUT links and forms, which can all be used to change the content in a section
* Supports redirects - a necessary feature when used with forms
* Custom javascript events
* Built in visual cues when loading new content - can be altered with css.

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

## Javascript Dependency
As well as the included ajax_pagination.js file, this gem uses jquery.ba-bbq.js and jquery.url.js, which are jquery plugins. They are included in the gem as assets already to simplify installation. ajax_pagination.js will automatically require jquery.ba-bbq.js, and jquery.url.js.

However, if you are already using them (especially if using a different version), simply ensure that your assets directory contains javascript files of the same name to shadow/override the file in the gem.

The other javascript dependencies rely on gems: jquery-rails, and jquery-historyjs. So if they are used, AJAX Pagination should play well with other gems using the libraries.

## Development
You are welcome to submit pull requests on GitHub at https://github.com/ronalchn/ajax_pagination, however, please be aware that submitting a pull request is assumed to grant to me non-exclusive, perpetual rights to the use of the software for any use whatsoever. This allows me to release the software under a more permissible license in the future if I want.

If you do not submit a pull request, your modifications will not be merged into the codebase.

## License
Copyright © 2012 Ronald Ping Man Chan

The source code in this gem is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. All source code, unless otherwise specified, is released under the MPL v2.

The following is my interpretation of what the MPL means. However, this should not be taken as legal advice, and I accept no liability for any damages due to using this information.

This gem is released under the Mozilla Public License, which means that it can be included in any open or closed source application. The MPL is copyleft, which means modifications to the gem can only be released if those modifications are also open source. However the MPL considers source file as the boundary between source licensed under the MPL, and source which may be under another license, allowing this gem to be readily used in applications which may be released under a different license.

For the purposes of this license, minified javascript is an executable form, since it is not the preferred form for modifications, and thus, concatenation of javascript assets with other javascript files which may be under different licenses to improve browser loading speed is permitted.


