require "spec_helper"

describe AjaxPagination::ControllerAdditions do
  def stub_pagination(name)
    @controller.stub!(:params).and_return({:pagination => name, :controller => "dummycontroller"})
  end
  def stub_request_format_html(bool)
    @controller.stub!(:request).and_return(stub(:format => stub(:html? => bool)))
  end
  def stub_lookup_context(result)
    @controller.stub!(:lookup_context).and_return(stub(:find_all => result))
  end
  before :each do
    @controller_class = Class.new
    @controller = @controller_class.new
    @controller.stub!(:params).and_return({})
    stub_request_format_html(false)
    @controller_class.send(:include, AjaxPagination::ControllerAdditions)
    @formatter = Class.new
    @formatter.stub!(:html).and_return(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15) # to detect how many times the function was called
    stub_lookup_context([]) # no partial matching
  end

  describe 'ajax_pagination' do
    it 'should not render when pagination parameter not defined' do
      @controller.ajax_pagination(@formatter).should be_false
      @controller.ajax_pagination(@formatter, :pagination => :page).should be_false
      @controller.ajax_pagination(@formatter, :pagination => 'page').should be_false
      @controller.ajax_pagination(@formatter, :pagination => 'page2').should be_false
      @formatter.html.should == 0
    end
    it 'should render when pagination parameter matches' do
      stub_pagination('page')
      @controller.ajax_pagination(@formatter).should be_true
      @formatter.html.should == 1 # detects html function was called once (but checking also calls the function) ...
      @controller.ajax_pagination(@formatter, :pagination => :page).should be_true
      @formatter.html.should == 3 # ... which is why the next check should be 2 more html function calls
      @controller.ajax_pagination(@formatter, :pagination => 'page').should be_true
      @formatter.html.should == 5
      stub_pagination('pageX')
      @controller.ajax_pagination(@formatter, :pagination => 'pageX').should be_true
      @formatter.html.should == 7
      stub_lookup_context(['matching_partial_found'])
      @controller.ajax_pagination(@formatter, :pagination => 'pageX').should be_true
      @formatter.html.should == 9
      stub_pagination('page')
      @controller.ajax_pagination(@formatter).should be_true
      @formatter.html.should == 11

    end
    it 'should not render when pagination parameter does not match' do
      stub_pagination('notpage')
      @controller.ajax_pagination(@formatter).should be_false
      @controller.ajax_pagination(@formatter, :pagination => :page).should be_false
      @controller.ajax_pagination(@formatter, :pagination => 'page').should be_false
      stub_pagination('notpageX')
      @controller.ajax_pagination(@formatter, :pagination => 'pageX').should be_false
      @formatter.html.should == 0
    end
  end

  describe 'ajax_pagination_displayed?' do
    it 'should display partial when format is not html' do
      @controller.ajax_pagination_displayed?.should be_true
    end
    it 'should display partial when format is html but pagination is not defined' do
      stub_request_format_html(true)
      @controller.ajax_pagination_displayed?.should be_true
    end
    it 'should display partial when .html?pagination=pagename' do
      stub_request_format_html(true)
      stub_pagination('page')
      @controller.ajax_pagination_displayed?.should be_true
      stub_pagination('page2')
      @controller.ajax_pagination_displayed?('page2').should be_true
      stub_pagination('page3')
      @controller.ajax_pagination_displayed?(:page3).should be_true
    end
    it 'should not display partial when .html?pagination!=pagename' do
      stub_request_format_html(true)
      stub_pagination('notpage')
      @controller.ajax_pagination_displayed?.should be_false
      stub_pagination('notpage2')
      @controller.ajax_pagination_displayed?('page2').should be_false
      stub_pagination('notpage3')
      @controller.ajax_pagination_displayed?(:page3).should be_false
    end
  end
end

