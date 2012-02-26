class SessionsController < ApplicationController
  def signin
    session[:admin] = true
    redirect_to root_url, :notice => "Successfully signed in as admin"
  end

  def signout
    session[:admin] = false
    redirect_to root_url, :notice => "Successfully signed out"
  end

  def count
    session[:count] ||= 0
    if request.post?
      session[:count] += 1
    end
    render :layout => false
  end
end
