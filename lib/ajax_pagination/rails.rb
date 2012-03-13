module AjaxPagination
  class Engine < ::Rails::Engine
    initializer 'ajax_pagination.actionpack_additions' do
      ActiveSupport.on_load(:action_controller) do
        include AjaxPagination::ControllerAdditions
      end
      ActiveSupport.on_load(:action_view) do
        include AjaxPagination::HelperAdditions
      end
    end

    initializer 'ajax_pagination.javascript_warnings' do
      if AjaxPagination.warnings.nil? # if not defined
        AjaxPagination.warnings = Rails.env == 'development' # default setting
      end
    end

  end
end
