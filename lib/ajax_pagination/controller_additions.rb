# Copyright (c) 2012 Ronald Ping Man Chan
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module AjaxPagination
  # This module is automatically added to all controllers
  module ControllerAdditions
    module ClassMethods
      # Adds default render behaviour for AJAX requests for a section with matching a certain name. By default,
      # this name is the empty string. However, it can be changed.
      #
      # An AJAX request for the matched section will render a partial, which by default, is the template named
      # "_#{ajax_section_name}", or if it does not exist, the view template matching the controller/action name.
      # By default there is no layout used.
      #
      # Options:
      # [:+section_id+]
      #   The AJAX section name which should be matched to invoke AJAX Pagination response. Defaults to "global".
      #
      # [:+render+]
      #   Overrides default render behaviour for AJAX Pagination, which is to render the partial with name matching the section_id option,
      #   or if it does not exist, renders the default template
      #
      # [:+only+]
      #   The actions that may trigger this render behaviour for AJAX requests. If an action is not included, it will
      #   not trigger this behaviour.
      #
      # [:+except+]
      #   Actions which will not trigger this render behaviour for AJAX requests.
      #
      def ajax_respond(options = {});
        # instead of defining default render normally, we save an unbound reference to original function in case it was already defined, since we want to retain the original behaviour, and add to it (if the method is redefined after, this new behaviour is lost, but at least we don't remove others' behaviour - note that this also allows multiple invocations of this with different parameters)
        section_id = options[:section_id] || "global"
        section = section_id.to_sym
        view = options[:render] || {}
        view = { :action => view } if view.kind_of? String
        only = options[:only] ? Array(options[:only]) : nil
        except = Array(options[:except]) || []

        if @_ajax_respond.nil? # has this method been called before?
          @_ajax_respond = {}
          _ajax_respond = @_ajax_respond # create reference to class instance variable
          # create default_render intercepting method (if not already defined)
          default_render = self.instance_method(:default_render) # get a reference to original method

          define_method(:default_render) do |*args|
            action = action_name.to_sym
            render = nil # nil means call original default_render method
            if ajax_section && _ajax_respond.has_key?(ajax_section) && request.format == "html"
              # might override render... let's find out
              if _ajax_respond[ajax_section][1].has_key?(action)
                render = _ajax_respond[ajax_section][1][action] # use action-specific render hash for this ajax_section (can still be nil)
              else
                render = _ajax_respond[ajax_section][0] # use default render hash for this ajax_section (can still be nil)
              end
            end
            if !render.nil?
              # AJAX response overriding normal default_render behaviour
              respond_to do |format|
                ajax_respond format, :section_id => ajax_section, :render => render
              end
            else # otherwise do what would have been done
              default_render.bind(self).call(*args) # call original method of the same name
            end
          end
        end

        @_ajax_respond[section] ||= [nil,{}]
        if only.nil?
          except.each {|x| @_ajax_respond[section][1][x.to_sym] = @_ajax_respond[section][0] unless @_ajax_respond[section][1].has_key? x.to_sym } # sets excluded actions to old default (if not already set)
          @_ajax_respond[section][0] = view # creates default for all other actions
        else
          @_ajax_respond[section][1] = Hash[(only - except).map { |x| [x.to_sym,view] }] # sets specific actions to view render options
        end
      end
    end
    def self.included(base)
      base.extend ClassMethods

      if AjaxPagination.redirect_after_filter == true
        base.after_filter :ajax_pagination_redirect
      end

      base.before_filter do
        # simply manipulating querystring will not get ajax response (in production mode)
        if request.xhr? || Rails.env == 'development'
          @_ajax_section = request.GET[:ajax_section]
          @_ajax_section = @_ajax_section.to_sym unless @_ajax_section.nil?
          params.delete(:ajax_section) if request.get?
        end
      end
    end

    # Returns the name of the ajax section to be responded to, if present. Otherwise this is not an AJAX Pagination request
    # (ie. this is otherwise a normal full page request). When no specific ajax section is requested, returns nil.
    def ajax_section
      @_ajax_section
    end

    # Registers an ajax response in html format when a request is made by AJAX Pagination (in which case ajax_section.nil? is false).
    # AJAX Pagination uses this response to render only the content which has changed. When this format is triggered,
    # a partial is passed back, and sent to AJAX Pagination as a function argument in javascript.
    #
    # Call this method in a respond_to block, in a controller action:
    #
    #   class CommentsController < ApplicationController
    #     def index
    #       @comments = Comment.all
    #       respond_to do |format|
    #         format.html # index.html.erb
    #         ajax_respond(format)
    #       end
    #     end
    #   end
    #
    # Options:
    # [:+section_id+]
    #   Changes the AJAX section name triggering this response. Triggered when ajax_section == options [:section_id].
    #   Defaults to "global"
    #
    # [:+render+]
    #   Changes the default template/partial that is rendered by this response. The value can be any object,
    #   and is rendered directly. The render behaviour is the same as the render method in controllers. If this option is not used,
    #   then the default is a partial of the same name as :section_id, if it exists, otherwise, if it does not,
    #   the default template is rendered (ie. the :controller/:action.:format view file). By default, no layout is used
    #   to render the template/partial. It can be set by passing in a layout key.
    #
    #     def welcome
    #       respond_to do |format|
    #         format.html
    #         ajax_respond format, :section_id => :menu, :render => {:file => "pages/welcome"}
    #       end
    #     end
    #
    def ajax_respond(format,options = {})
      if ajax_section == (options[:section_id] || 'global').to_sym
        render = options[:render] || {}
        if !render.empty?
          view = render # render non partial
        elsif lookup_context.find_all(controller_path + "/_" + ajax_section.to_s).any?
          view = {:partial => ajax_section.to_s} # render partial of the same name as section_id
        else # render usual view
          view = {}
        end
        view = { :layout => false }.merge(view); # set default of no layout rendered
        format.html { render view }
        return true
      else
        return false
      end
    end

    # Tests whether an AJAX Pagination partial might be displayed in the view. If the response is not directly controlled by
    # AJAX Pagination, it will return true, because the partial might be displayed. The response is handled by AJAX Pagination
    # if the format is html, and the ajax_section parameter is set. If it is set, then it will return whether
    # ajax_section == section_id (the name of the section, which defaults to page).
    #
    # In effect, this method returns (ajax_section.nil? || ajax_section == section_id.to_sym)
    #
    # This method is a convenience function so that the controller does not need to perform heavy computation which might only
    # be required if only a certain section is displayed (for an AJAX request).
    #
    # For example, suppose an index page contains two ajax_section containers, one for upcoming posts, and one for published
    # posts, then you might use:
    # 
    #   class PostsController < ApplicationController
    #     def index
    #       if ajax_section? :page do
    #         @posts = Post.published
    #         @posts.each do |post|
    #           post.heavycomputation
    #         end
    #       end
    #       if current_user.is_admin && ajax_section? :upcomingpage do
    #         @upcomingposts = Post.upcoming
    #         @upcomingposts.each do |post|
    #           post.heavycomputation
    #         end
    #       end
    #       respond_to do |format|
    #         format.html # index.html.erb
    #         ajax_respond format, :section_id => 'page'
    #         ajax_respond format, :section_id => 'upcomingpage'
    #       end
    #     end
    #   end
    #
    # The heavy computation will only be performed on posts which will be displayed when AJAX Pagination only wants a partial.
    def ajax_section?(section_id = :global)
      (ajax_section.nil?) || (ajax_section == section_id.to_sym)
    end

    # This after_filter method is automatically included by AJAX Paginate, and does not need to be included manually. However,
    # it can be disabled in the initializer, and if desired, enabled in specific controllers by adding this method as an after_filter.
    #
    # This after_filter method will intercept any redirects for AJAX calls by
    # AJAX Paginate, and turn it into a Status 200 OK response, with an extra Location: header.
    #
    # This is used because of the transparent redirection otherwise done by browsers on receiving a 30x status code. The AJAX
    # code cannot then detect that the request was redirected, and is therefore unable to change the url in the History object.
    # AJAX Pagination javascript code will detect any 200 OK responses with a Location header, and treat this as a redirection.
    #
    # This filter should not affect other uses, because only AJAX calls trigger this. In addition, a ?pagination= parameter is required.
    # Therefore other AJAX libraries or usage otherwise should not be affected.
    def ajax_pagination_redirect
      if ajax_section && response.status==302 # alter redirect response so that it can be detected by the client javascript
        response.status = 200 # change response to OK, location header is preserved, so AJAX can get the new page manually
      end
    end
  end
end

