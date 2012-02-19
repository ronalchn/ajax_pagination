require "spec_helper"

describe AjaxPagination::ControllerAdditions do
  def stub_pagination(name)
    @controller.stub!(:params).and_return({:pagination => name})
  end
  def stub_request_format_js(bool)
    @controller.stub!(:request).and_return(stub(:format => stub(:js? => bool)))
  end
  before :each do
    @controller_class = Class.new
    @controller = @controller_class.new
    @controller.stub!(:params).and_return({})
    stub_request_format_js(false)
    @controller_class.send(:include, AjaxPagination::ControllerAdditions)
    @formatter = Class.new
    @formatter.stub!(:js).and_return(0,1,2,3,4,5,6,7,8,9,10) # to detect how many times the function was called
  end

  describe 'ajax_pagination' do
    it 'should not render when pagination parameter not defined' do
      @controller.ajax_pagination(@formatter).should be_false
      @controller.ajax_pagination(@formatter, :pagination => :page).should be_false
      @controller.ajax_pagination(@formatter, :pagination => 'page').should be_false
      @controller.ajax_pagination(@formatter, :pagination => 'page2').should be_false
      @formatter.js.should == 0
    end
    it 'should render when pagination parameter matches' do
      stub_pagination('page')
      @controller.ajax_pagination(@formatter).should be_true
      @formatter.js.should == 1 # detects js function was called once (but checking also calls the function) ...
      @controller.ajax_pagination(@formatter, :pagination => :page).should be_true
      @formatter.js.should == 3 # ... which is why the next check should be 2 more js function calls
      @controller.ajax_pagination(@formatter, :pagination => 'page').should be_true
      @formatter.js.should == 5
      stub_pagination('pageX')
      @controller.ajax_pagination(@formatter, :pagination => 'pageX').should be_true
      @formatter.js.should == 7
    end
    it 'should not render when pagination parameter does not match' do
      stub_pagination('notpage')
      @controller.ajax_pagination(@formatter).should be_false
      @controller.ajax_pagination(@formatter, :pagination => :page).should be_false
      @controller.ajax_pagination(@formatter, :pagination => 'page').should be_false
      stub_pagination('notpageX')
      @controller.ajax_pagination(@formatter, :pagination => 'pageX').should be_false
      @formatter.js.should == 0
    end
  end

  describe 'ajax_pagination_displayed?' do
    it 'should display partial when format is not js' do
      @controller.ajax_pagination_displayed?.should be_true
    end
    it 'should display partial when format is js but pagination is not defined' do
      stub_request_format_js(true)
      @controller.ajax_pagination_displayed?.should be_true
    end
    it 'should display partial when .js?pagination=pagename' do
      stub_request_format_js(true)
      stub_pagination('page')
      @controller.ajax_pagination_displayed?.should be_true
      stub_pagination('page2')
      @controller.ajax_pagination_displayed?('page2').should be_true
      stub_pagination('page3')
      @controller.ajax_pagination_displayed?(:page3).should be_true
    end
    it 'should not display partial when .js?pagination!=pagename' do
      stub_request_format_js(true)
      stub_pagination('notpage')
      @controller.ajax_pagination_displayed?.should be_false
      stub_pagination('notpage2')
      @controller.ajax_pagination_displayed?('page2').should be_false
      stub_pagination('notpage3')
      @controller.ajax_pagination_displayed?(:page3).should be_false
    end
  end
end

