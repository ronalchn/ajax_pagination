# AJAX Pagination
[![Build Status](https://secure.travis-ci.org/ronalchn/ajax_pagination.png?branch=master)](http://travis-ci.org/ronalchn/ajax_pagination)

[Wiki](https://github.com/ronalchn/ajax_pagination/wiki) | [RDoc](http://rdoc.info/gems/ajax_pagination/frames) | [Changelog](https://github.com/ronalchn/ajax_pagination/blob/master/CHANGELOG.md)

Handles AJAX pagination for you, by hooking up the links you want to load content with javascript in designated page containers. Each webpage can have multiple page containers, each with a different set of pagination links. The page containers can be nested. Degrades gracefully when javascript is disabled.

Basically, there is a helper function to use to create a section in your webpage, where content can be changed. Links can reference the section, and thus load new content into it.

For more, see [Introduction and Background](https://github.com/ronalchn/ajax_pagination/wiki/Introduction-and-Background).

This gem currently assumes you are using Rails 3.1+, and the assets pipeline for the javascript and css files (see the Installation section). For Rails 3.0, see information below - adding support in progress.

## Installation with Asset Pipeline
Add to your Gemfile:

    gem 'ajax_pagination'

and run the bundle install command.

Then add to your asset manifests,

```js
// app/assets/javascripts/application.js
//= require jquery
//= require jquery_ujs
//= require history
//= require ajax_pagination
```

```css
/* app/assets/stylesheets/application.css
 *= require ajax_pagination
 */
```

## Installation on Rails 3.0, or without asset pipeline

To use this on Rails 3.0, or without using the assets pipeline, here is the [Installation without Assets Pipeline](https://github.com/ronalchn/ajax_pagination/wiki/Installing-without-Pipeline) guide, and you must use the github version (in your Gemfile):

```rb
gem 'ajax_pagination', :git => "git://github.com/ronalchn/ajax_pagination.git"
```

The generator for this has not yet been released to rubygems. Please notify me if it works in a Rails 3.0 application, before I release this to rubygems.

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

If you want to use this program under a different license, please contact me.
All pull requests to my repository will be assumed to assign to me non-exclusive rights for perpertual usage for any use whatsoever for those modifications to Ronald Ping Man Chan. If you do not have the power to assign that right, do not submit a pull request. This allows me to release the software under a more permissible license in the future if I want.
Ronald

The software is released under LGPL. The LGPL License on this software means that this Gem can be used in any software (proprietary or otherwise), by using the gem command. However, the gem cannot be included directly in proprietary software (eg. as a plugin), without distributions of the software being under LGPL. Distribution of this Gem must be released under the LGPL as well.
