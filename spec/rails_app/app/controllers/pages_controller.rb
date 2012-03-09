class PagesController < ApplicationController
  respond_to :html, :js, :only => :about

  def readme
    @readme = IO.read(File.expand_path("../../../../../README.md",__FILE__))
    respond_to do |format|
      format.html
      ajax_respond format, :pagination => "", :render => {:file => "pages/readme", :layout => "ajax"}
    end
  end

  def about
  end

  def welcome
    respond_to do |format|
      format.html
      ajax_respond format, :pagination => "", :render => { :layout => "ajax" }
    end
  end

  def warnings
    respond_to do |format|
      format.html
      ajax_respond format, :pagination => "disable", :render => { :layout => "ajax" }
    end
  end
end
