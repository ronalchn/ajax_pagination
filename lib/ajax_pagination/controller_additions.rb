module AjaxPagination
  # This module is automatically added to all controllers
  module ControllerAdditions
    module ClassMethods
      # Adds default render behaviour for requests with a pagination parameter matching a certain name. By default, this name is the empty string. However, it can be changed.
      # Options:
      # [:+pagination+]
      #   The pagination name which should be matched to invoke AJAX Pagination response. Defaults to the empty string "". This is unlike other
      #   methods which default to "page". However, this is a better default in this case because this affects more than one controller/action.
      #
      # [:+render+]
      #   Overrides default render behaviour for AJAX Pagination, which is to render the partial with name matching the pagination option,
      #   or if it does not exist, renders the default template
      #
      def ajax_pagination(options = {});
        # instead of defining default render normally, we save an unbound reference to original function in case it was already defined, since we want to retain the original behaviour, and add to it (if the method is redefined after, this new behaviour is lost, but at least we don't remove others' behaviour - note that this also allows multiple invocations of this with different parameters)
        default_render = self.instance_method(:default_render) # get a reference to original method
        pagination = options[:pagination] || ""
        view = options[:render] || nil
        define_method(:default_render) do |*args|
          paramspagination = request.GET[:pagination] || params[:pagination]
          if paramspagination && paramspagination == pagination && request.format == "html" # override if calling AJAX Pagination
            unless view
              if lookup_context.find_all("#{params[:controller]}/_#{paramspagination}").any?
                view = { :partial => paramspagination } # render partial, layout is off
              else
                view = { :layout => false } # render default view, but turn off layout
              end
            end
            respond_to do |format|
              ajax_pagination format, :pagination => pagination, :render => view
            end
          else # otherwise do what would have been done
            default_render.bind(self).call(*args) # call original method of the same name
          end
        end
      end
    end
    def self.included(base)
      base.extend ClassMethods
    end
    # Registers an ajax response in html format when params [:pagination] matches options [:pagination] ( = "page" by default).
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
    #         ajax_pagination(format)
    #       end
    #     end
    #   end
    #
    # Options:
    # [:+pagination+]
    #   Changes the pagination name triggering this response. Triggered when params [:pagination] == options [:pagination].
    #   Defaults to "page"
    #
    # [:+render+]
    #   Changes the default template/partial that is rendered by this response. The value can be any object,
    #   and is rendered directly. The render behaviour is the same as the render method in controllers. If this option is not used,
    #   then the default is a partial of the same name as :pagination, if it exists, otherwise, if it does not,
    #   the default template is rendered (ie. the :controller/:action.:format view file). By default, no layout is used
    #   to render the template/partial. It can be set by passing in a layout key.
    #
    #     def welcome
    #       respond_to do |format|
    #         format.html
    #         ajax_pagination format, :pagination => :menu, :render => {:file => "pages/welcome"}
    #       end
    #     end
    #
    def ajax_pagination(format,options = {})
      paramspagination = request.GET[:pagination] || params[:pagination]
      if paramspagination == (options[:pagination] || 'page').to_s
        if options[:render]
          view = options[:render] # render non partial
        elsif lookup_context.find_all(params[:controller] + "/_" + paramspagination).any?
          view = {:partial => paramspagination} # render partial of the same name as pagination
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
    # if the format is html, and the params [:pagination] parameter is set. If it is set, then it will return whether
    # params [:pagination] == pagination (the name of the pagination set, which defaults to page).
    #
    # This method is a convenience function so that the controller does not need to perform heavy computation which might only
    # be required if a certain pagination partial is displayed.
    #
    # For example, suppose an index page contains two sets of pagination partials, one for upcoming posts, and one for published
    # posts, then you might use:
    # 
    #   class PostsController < ApplicationController
    #     def index
    #       if ajax_pagination_displayed? do
    #         @posts = Post.published
    #         @posts.each do |post|
    #           post.heavycomputation
    #         end
    #       end
    #       if current_user.is_admin && ajax_pagination_displayed? :upcomingpage do
    #         @upcomingposts = Post.upcoming
    #         @upcomingposts.each do |post|
    #           post.heavycomputation
    #         end
    #       end
    #       respond_to do |format|
    #         format.html # index.html.erb
    #         ajax_pagination format
    #         ajax_pagination format, :pagination => 'upcomingpage'
    #       end
    #     end
    #   end
    #
    # The heavy computation will only be performed on posts which will be displayed when AJAX Pagination only wants a partial.
    def ajax_pagination_displayed?(pagination = :page)
      paramspagination = request.GET[:pagination] || params[:pagination]
      (!request.format.html?) || (paramspagination.nil?) || (paramspagination == pagination.to_s)
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
      paramspagination = request.GET[:pagination] || params[:pagination]
      if request.xhr? && paramspagination && response.status==302 # alter redirect response so that it can be detected by the client javascript
        response.status = 200 # change response to OK, location header is preserved, so AJAX can get the new page manually
      end
    end
  end
end

