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
      if params[:pagination] == (options[:pagination] || 'page')
        partial = options[:partial] || params[:pagination]
        format.js { render :inline => "ajaxPagination.display_pagination_content(\"#{params[:pagination]}\",\"#{request.url}\",\"<%= raw escape_javascript(render(\"#{partial}\")) %>\");" }
        return true
      else
        return false
      end
    end
  end
end
if defined? ActionController
  ActionController::Base.class_eval do
    include AjaxPagination::ControllerAdditions
  end
end

