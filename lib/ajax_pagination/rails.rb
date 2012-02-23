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
  end
end
