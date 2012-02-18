module AjaxPagination
  module ControllerAdditions
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

