module AjaxPagination
  # This module is automatically added to all controllers
  module ControllerAdditions
    # Registers a javascript format when params [:pagination] matches options [:pagination] ( = "page" by default).
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
    # [:+partial+]
    #   Changes the partial that is returned by this response. Defaults to options [:pagination].
    #
    def ajax_pagination(format,options = {})
      if params[:pagination] == (options[:pagination] || 'page').to_s
        partial = options[:partial] || params[:pagination]
        format.js { render :inline => "ajaxPagination.display_pagination_content(\"#{params[:pagination]}\",\"#{request.url}\",\"<%= raw escape_javascript(render(\"#{partial}\")) %>\");" }
        return true
      else
        return false
      end
    end

    # Tests whether an AJAX Pagination partial might be displayed in the view. If the response is not directly controlled by
    # AJAX Pagination, it will return true, because the partial might be displayed. The response is handled by AJAX Pagination
    # if the format is js (javascript), and the params [:pagination] parameter is set. If it is set, then it will return whether
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
      (!request.format.js?) || (params[:pagination].nil?) || (params[:pagination] == pagination.to_s)
    end
  end
end
if defined? ActionController
  ActionController::Base.class_eval do
    include AjaxPagination::ControllerAdditions
  end
end

