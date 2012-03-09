class SessionsController < ApplicationController
  def count
    session[:count] ||= 0
    if request.post?
      session[:count] += 1
    end
    render :layout => false
  end
end
