# Copyright (c) 2012 Ronald Ping Man Chan
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module AjaxPagination
  # This module is automatically added to all views, providing helper methods.
  module HelperAdditions
    # Renders a partial wrapped in a div tag. When the page content displayed in the partial needs changing
    # AJAX Pagination will replace content inside this div tag, with the new content returned by the controller
    # (To manage that, see +ajax_respond+ in ControllerAdditions).
    # 
    # Call this method instead of +render+ to display the partial representing the page content:
    #
    #   Listing Comments:
    #   
    #   <%= ajax_section %>
    #   
    #   <%= link_to 'New Comment', new_comment_path %>
    #
    # If you prefer to can render yourself, or call another function instead (useful for using this in the
    # application layout), you can pass in a block. Any content wrapped by this section will be changed
    # when paginating. A possible way to use this function by passing a block in an application layout is shown:
    # 
    #   <%= ajax_links :section_id => "global", :class => "menu" do %>
    #     <ul>
    #       <li><%= link_to "Home", root_url %></li>
    #       <li><%= link_to "Posts", posts_url %></li>
    #       <li><%= link_to "Changelog", changelog_url %></li>
    #       <li><%= link_to "Readme", pages_readme_url %></li>
    #       <li><%= link_to "About", pages_about_url %></li>
    #     </ul>
    #   <% end %>
    #   <%= ajax_section :id => "global" do %>
    #     <%= yield %>
    #   <% end %>
    #
    # Options:
    # [:+id+]
    #   Changes the AJAX section name, which is used for requesting new content, and to uniquely identify the
    #   wrapping div tag. This section id will be referred to in the controller
    #   respond_to block. Defaults to "global".
    #
    # [:+render+]
    #   Changes the partial which is rendered. Defaults to +options [:name]+. The partial should generally
    #   be the same as that given in the controller respond_to block, unless you are doing something strange. If a
    #   block is passed to the function, this option is ignored. You can also pass options instead to render other
    #   files, in which case, the behaviour is the same as the render method in views.
    #
    # [:+reload+]
    #   Can be used to tweak the logic detecting that a page section is trying to reload the same page content. If there
    #   are multiple urls that loads the same page content into a section, AJAX Pagination will not normally detect that.
    #   Since the urls are different, it is assumed they have different content, therefore, a new history item will
    #   normally be added for it, and when jumping between two history items with the same content in this section,
    #   but different urls, the content will still be reloaded.
    #
    #   If this option is used, it identifies certain areas of the url which must differ if the page content will be different.
    #   If all areas specified is the same, two urls will be assumed to reference the same content for this section.
    #
    #   If passed a hash of the form :+query+ => "parametername", AJAX Pagination will parse the url, to find
    #   the parameter +parametername+ inside the query string (ie. /path/?parametername=value).
    #   
    #   If passed a hash of the form :+urlregex+ => "regularexpression", AJAX Pagination will apply the regular
    #   expression to the url. If a particular subexpression of the match changes, the urls are regarded as different. The
    #   subexpression used defaults to the whole match. If the hash includes :+regexindex+ => N, the Nth subexpression
    #   is used. If the hash also includes :+urlpart+, then the regular expression will only be applied to part of the
    #   url. The part it is applied to depends on the string passed. Allowed strings are any attributes as given at
    #   https://github.com/allmarkedup/jQuery-URL-Parser. Possible attributes include: "source", "protocol", "host",
    #   "port", "relative", "path", "directory", "file", "query".
    #   
    #   Different parts of the url can be watched for any changes, by passing an array of hashes. For example:
    #   
    #     <%= ajax_section :reload => [{:urlregex => "page=([0-9]+)", :regexindex => 1},{:query => "watching"}] %>
    #   
    # [:+image+]
    #   Specify another image to be used as the loading image. The string passed is an image in the assets pipeline.
    #   If not specified, the default loading image is used.
    #
    # [:+loadzone+]
    #   Instead of using the ajax_loadzone tag, this option can be set to true. Everything inside this tag
    #   will then be regarded as a loading zone, and the visual loading cues will apply to all the content here.
    #
    # [:+history+]
    #   Whether the url changes, as if an new page was accessed, including adding page to the history. This defaults to
    #   true. Therefore, (sub)pages accessed through AJAX Pagination act as if a whole new page was accessed.
    #
    #   If false then it is as if no new page is accessed, and the history is not changed. It therefore appears as if following
    #   the link simply creates a cool AJAX effect on the current page.
    #
    def ajax_section(options = {})
      section_id = (options[:id] || 'global').to_s # by default the name of the section is 'global'
      partial = options[:render] || section_id # default partial rendered is the name of the section
      divoptions = { :id => section_id, :class => "ajax_section" }
      data = {};
      if options.has_key? :history
        data[:history] = (options[:history] != false)
      end
      case options[:reload].class.to_s
      when "Hash", "Array"
        data[:reload] = options[:reload]
      end
      data[:image] = asset_path options[:image] if options[:image].class.to_s == "String"
      divoptions["data-pagination"] = data.to_json if !data.empty?
      if options[:loadzone]
        divoptions[:class] = "ajax_section ajax_loadzone"
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
    # displaying AJAX links which you do not want to disable, as well as content you wish to disable,
    # your partial might contain:
    #   <% ajax_links :section_id => "page" do %>
    #     <%= will_paginate @objects %>
    #   <% end %>
    #   <%= ajax_loadzone do %>
    #     All content here is covered by a semi-transparent rectangle.
    #     A loading image is displayed on top, and any links here are unclickable
    #   <% end %>
    #
    def ajax_loadzone()
      content_tag :div, :class => "ajax_loadzone", :style => "position: relative;" do
        yield
      end
    end

    # Used to wrap ordinary links, which will be treated as AJAX links. Only ordinary links are altered.
    # If the link contains a data-remote, data-method, data-confirm attribute, it will not be ajaxified by this container.
    #
    # Instead of using ajax_link_to for every link, the following can be used:
    #
    # ajax_links :section_id => "global" do
    #   link_to "My link", link_url
    #   link_to "Back", back_url
    # end
    #
    # This allows a :section_id option to apply to all links within the block, instead of specifying the same option
    # on each link. The default :section_id is "global" if not otherwise specified.
    #
    def ajax_links(options = {})
      section_id = (options[:section_id] || 'global').to_s
      content_tag :div, "data-ajax_section_id" => section_id, :class => ((Array(options[:class]) || []) + ["ajaxpagination"]).join(" ") do
        yield
      end
    end

    # modifies the html options, so that it calls AJAX Pagination. This method adds the appropriate parameters to make an AJAX call via
    # AJAX Pagination, using jquery-ujs.
    #
    # More specifically, it ensures the following attributes are defined :remote => true, "data-type" => 'html', :section_id => ?.
    # The section_id attribute must be defined, or else it defaults to the empty string "global".
    # This link always sets data-remote to true - setting to false is not allowed, since AJAX Pagination would not be triggered.
    #
    # Below is an alternative way to create an ajax link instead of ajax_link_to
    #
    #   <%= link_to "Name", posts_url, ajax_options :section_id => "page" %>
    #
    def ajax_options(html_options = {})
      html_options["data-ajax_section_id".to_sym] = (html_options.delete(:section_id) || "global").to_s # renames the option section_id to data-ajax_section_id
      html_options[:remote] = true
      html_options["data-type".to_sym] ||= (html_options.delete("data-type") || 'html').to_s
      html_options
    end

    # Wrapper for link_to, but makes the link trigger an AJAX call through AJAX Pagination.
    # The arguments passed are in the same order as link_to the advantage of using this helper
    # is that if the implementation is changed, links using this helper will still work. Internally uses ajax_options
    #
    # The example below creates a link "Name", which when clicked, will load posts_url into the section of the page named
    # "page" using AJAX.
    #
    #   <%= ajax_link_to "Name", posts_url, :section_id => "page" %>
    #
    def ajax_link_to(*args, &block)
      if block_given? # inject new html_options argument and call link_to
        html_options = args[1] || {}
        args[1] = ajax_options html_options
        link_to(*args,&block)
      else
        html_options = args[2] || {}
        args[2] = ajax_options html_options
        link_to(*args)
      end
    end

    # Wrapper for form_tag, following are equivalent:
    #
    #   <%= ajax_form_tag posts_url, :method => "post", :class => "myclass", :section_id => "page" do %>
    #     ...
    #   <% end %>
    #
    #   <%= form_tag posts_url, ajax_options :method => "post", :class => "myclass", :section_id => "page" do %>
    #     ...
    #   <% end %>
    #
    def ajax_form_tag(url_for_options = {}, options = {}, &block)
      options = ajax_options(options)
      if block_given?
        form_tag(url_for_options,options, &block)
      else
        form_tag(url_for_options,options)
      end
    end

    # Wrapper for form_for. The following are equivalent
    #
    #   <%= ajax_form_for @post, :method => "post", :html => {:class => "myclass", :section_id => "menu"} do %>
    #     ...
    #   <% end %>
    #
    #   <%= form_for @post, :method => "post", :html => ajax_options({:class => "myclass", :section_id => "menu"}) do %>
    #     ...
    #   <% end %>
    #
    # Please be aware that in the second alternative, you should never set :remote => false manually, eg:
    #
    #   <%= form_tag @post, :remote => false, :html => ajax_options(:section_id => "menu") do %><!-- Never Do This!!! -->
    #
    # This will prevent AJAX Pagination from being called.
    #
    # If you are using Formtastic or Simple Form gems, you can use the second method to add AJAX Pagination functionality
    # at the same time. This form_for helper is only a convenience method (shorthand)
    #
    def ajax_form_for(record, options = {}, &block)
      raise ArgumentError, "Missing block" unless block_given?
      options[:html] ||= {}
      options[:html] = ajax_options options[:html]
      options.delete(:remote) # html sub-hash already has remote set true
      form_for(record,options,&block)
    end

  end
end

