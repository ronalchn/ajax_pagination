require "spec_helper"

describe AjaxPagination::HelperAdditions do
  module BlockPassThrough
    def content_tag(name, options = {})
      yield
    end
  end
  before :each do
    @view_class = Class.new
    @view = @view_class.new
    @view.stub!(:count).and_return(0,1,2,3,4,5,6,7) # detects how many times the method is called
    @view_class.send(:include, AjaxPagination::HelperAdditions)
    @view_class.send(:include, BlockPassThrough) # passes through block return value directly
  end
  describe 'ajax_section' do
    it 'should render partial requested, default of page with no arguments' do
      @view.should_receive(:render).with('global')
      @view.ajax_section
      @view.should_receive(:render).with('page2')
      @view.ajax_section :id => :page2 # renders the partial named :id if :partial not defined
      @view.should_receive(:render).with('page3')
      @view.ajax_section :render => 'page3' # if partial defined, renders partial
      @view.should_receive(:render).with('pageX')
      @view.ajax_section :id => 'page10', :render => 'pageX' # even if id also defined as different value
    end
  end
  describe 'ajax_loadzone' do
    it 'should yield once to block' do
      html = @view.ajax_loadzone do
        @view.count
        true
      end
      html.should be_true
      @view.count.should == 1
      html = @view.ajax_loadzone do
        @view.count
        false
      end
      html.should be_false
      @view.count.should == 3
    end
  end

end
