class PagesController < ApplicationController
  def readme
    @readme = IO.read(File.expand_path("../../../../../README.md",__FILE__))
    respond_to do |format|
      format.html
      ajax_pagination format, :pagination => :menu, :partial => {:file => "pages/readme"}
    end
  end

  def about
    respond_to do |format|
      format.html
      ajax_pagination format, :pagination => :menu, :partial => {:file => "pages/about"}
    end
  end

  def welcome
    respond_to do |format|
      format.html
      ajax_pagination format, :pagination => :menu, :partial => {:file => "pages/welcome"}
    end
  end
end
