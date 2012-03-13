class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :slowajaxload
  ajax_respond :render => { :layout => "ajax" }
  def slowajaxload
    if (!ajax_section.nil?) && Rails.env == "test"
      delay = 0
      delay = ENV['AJAX_DELAY'] if ENV['AJAX_DELAY']
      sleep(delay.to_f)
    end
  end

end
