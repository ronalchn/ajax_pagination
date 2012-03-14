class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :slowajaxload
  ajax_respond :section_id => "global", :render => { :layout => "ajax" }, :except => "about"
  ajax_respond :section_id => "global", :render => { :layout => "ajax" }, :only => "about" # assuming :except option works, this line tests the :only option
  def slowajaxload
    if (!ajax_section.nil?) && Rails.env == "test"
      delay = 0
      delay = ENV['AJAX_DELAY'] if ENV['AJAX_DELAY']
      sleep(delay.to_f)
    end
  end

end
