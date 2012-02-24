class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :slowajaxload
  ajax_pagination :pagination => 'menu', :render => { :layout => "flash" }
  def slowajaxload
    if params[:pagination] && Rails.env == "test"
      sleep(0.5)
    end
  end

end
