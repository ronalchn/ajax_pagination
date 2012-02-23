begin
  require 'will_paginate' if Gem::Specification.find_by_name('will_paginate') # needed for testing dummy application
rescue Gem::LoadError # in case using version without fix for this
end

module AjaxPagination
  # This module is automatically added to all views, providing helper methods.
  module HelperAdditions
    # Renders a partial wrapped in a div tag. When the page content displayed in the partial needs changing
    # AJAX Pagination will replace content inside this div tag, with the new content returned by the controller
    # (To manage that, see +ajax_pagination+ in ControllerAdditions).
    # 
    # Call this method instead of +render+ to display the partial representing the page content:
    #
    #   Listing Comments:
    #   
    #   <%= ajax_pagination %>
    #   
    #   <%= link_to 'New Comment', new_comment_path %>
    #
    # If you prefer to can render yourself, or call another function instead (useful for using this in the
    # application layout), you can pass in a block. Any content wrapped by the pagination tag will be changed
    # when paginating. A possible way to use this function by passing a block in an application layout is shown:
    # 
    #   <div class="ajaxpagination menu" data-pagination="menu">
    #     <ul>
    #       <li><%= link_to "Home", root_url %></li>
    #       <li><%= link_to "Posts", posts_url %></li>
    #       <li><%= link_to "Changelog", changelog_url %></li>
    #       <li><%= link_to "Readme", pages_readme_url %></li>
    #       <li><%= link_to "About", pages_about_url %></li>
    #     </ul>
    #   </div>
    #   <%= ajax_pagination :pagination => "menu", :reload => {:urlpart => "path", :urlregex => "^.*$"} do %>
    #     <%= yield %>
    #   <% end %>
    #
    # Options:
    # [:+pagination+]
    #   Changes the pagination name, which is used for requesting new content, and to uniquely identify the
    #   wrapping div tag. The name passed here should be the same as the pagination name used in the controller
    #   respond_to block. Defaults to "page".
    #
    # [:+render+]
    #   Changes the partial which is rendered. Defaults to +options [:pagination]+. The partial should generally
    #   be the same as that given in the controller respond_to block, unless you are doing something strange. If a
    #   block is passed to the function, this option is ignored. You can also pass options instead to render other
    #   files, in which case, the behaviour is the same as the render method in views.
    #
    # [:+reload+]
    #   Used to detect whether the partial needs reloading, based on how the url changes. When pagination links are
    #   clicked, they are easily detected, and will load the new content automatically. When the browser
    #   back/forwards buttons are used, AJAX Pagination needs to know whether the content inside this pagination
    #   partial needs reloading. This is not certain, because the webpage may contain multiple pagination partials,
    #   and moreover, the page may have other functionality using the History.pushState feature. Defaults to nil.
    #   
    #   If passed a hash of the form :+query+ => "parametername", AJAX Pagination will parse the url, to find
    #   the parameter +parametername+ inside the query string (ie. /path/?parametername=value). When it changes,
    #   the partial is reloaded.
    #   
    #   If passed a hash of the form :+urlregex+ => "regularexpression", AJAX Pagination will apply the regular
    #   expression to the url. If a particular subexpression of the match changes, the partial is reloaded. The
    #   subexpression used defaults to the whole match. If the hash includes :+regexindex+ => N, the Nth subexpression
    #   is used. If the hash also includes :+urlpart+, then the regular expression will only be applied to part of the
    #   url. The part it is applied to depends on the string passed. Allowed strings are any attributes as given at
    #   https://github.com/allmarkedup/jQuery-URL-Parser. Possible attributes include: "source", "protocol", "host",
    #   "port", "relative", "path", "directory", "file", "query". Notice in the above example for the application
    #   layout, how :urlpart => "path" is passed as a reload condition.
    #   
    #   Different parts of the url can be watched for any changes, by passing an array of hashes. For example:
    #   
    #     <%= ajax_pagination :reload => [{:urlregex => "page=([0-9]+)", :regexindex => 1},{:query => "watching"}] %>
    #   
    #   If nil, AJAX Pagination acts as if it was passed {:query => options [:pagination]}.
    #
    # [:+loadzone+]
    #   Instead of using the ajax_pagination_loadzone tag, this option can be set to true. Everything inside this tag
    #   will then be regarded as a loading zone, and the visual loading cues will apply to all the content here.
    #
    def ajax_pagination(options = {})
      pagination = options[:pagination] || 'page' # by default the name of the pagination is 'page'
      partial = options[:render] || pagination # default partial rendered is the name of the pagination
      reload = options[:reload]
      divoptions = { :id => "#{pagination}_paginated_section", :class => "paginated_section" }
      case reload.class.to_s
      when "String"
        divoptions["data-pagination"] = reload
      when "Hash", "Array"
        divoptions["data-pagination"] = reload.to_json
      end
      if options[:loadzone]
        divoptions[:class] = "paginated_section paginated_content"
        divoptions[:style] = "position: relative;"
      end
      content_tag :div, divoptions do
        if block_given?
          yield
        else
          render partial
        end
      end
    end

    # Wraps content in a div tag. AJAX Pagination uses this to display visual loading cues. When a partial
    # is reloaded, it may take some time. In the meanwhile, AJAX Pagination will look in the partial amoung its
    # immediate child for this tag. If this tag exists, it will cover this tag with a semi-transparent
    # rectangle, and make the old partial unclickable (links and other elements are therefore disabled).
    # A loading image is also displayed above the content. Only one loading zone is allowed. The rest are ignored.
    #
    # Use this tag in your partial, wrapped around all the content you want to disable. For example, if you are
    # displaying pagination links which you do not want to disable, as well as content you wish to disable,
    # your partial might contain:
    #
    #   <%= will_paginate @objects, :params => { :pagination => nil } %>
    #   <%= ajax_pagination_loadzone do %>
    #     All content here is covered by a semi-transparent rectangle.
    #     A loading image is displayed on top, and any links here are unclickable
    #   <% end %>
    #
    def ajax_pagination_loadzone()
      content_tag :div, :class => "paginated_content", :style => "position: relative;" do
        yield
      end
    end
  end
end

