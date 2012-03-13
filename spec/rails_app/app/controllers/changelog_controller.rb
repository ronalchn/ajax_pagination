class ChangelogController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @changelogs = Changelog.paginate(:page => params[:page], :per_page => 2)

    respond_to do |format|
      format.html # index.html.erb
      ajax_respond format, :section_id => "page"
    end
  end
end
