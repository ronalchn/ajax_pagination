module AjaxPagination
  module HelperAdditions
    def ajax_pagination(options = {})
      pagination = options[:pagination] || 'page' # by default the name of the pagination is 'page'
      partial = options[:partial] || pagination # default partial rendered is the name of the pagination
      reload = options[:reload]
      divoptions = { :id => "#{pagination}_paginated_section", :class => "paginated_section" }
      case reload.class.to_s
      when "String"
        divoptions["data-reload"] = reload
      when "Hash", "Array"
        divoptions["data-reload"] = reload.to_json
      end
      content_tag :div, divoptions do
        render partial
      end
    end
    def ajax_pagination_loadzone()
      content_tag :div, :class => "paginated_content", :style => "position: relative" do
        yield
      end
    end
  end
end
if defined? ActionView
  ActionView::Base.class_eval do
    include AjaxPagination::HelperAdditions
  end
end

