require "spec_helper"

module SetAjaxSection
  def ajax_section= (name)
    @_ajax_section = name.to_sym
  end
  def controller_path
    "dummycontroller"
  end
end

describe AjaxPagination::ControllerAdditions do
  def stub_ajax_section(name)
    @controller.ajax_section = name
  end
  def stub_request_format_html(bool)
    @controller.stub!(:request).and_return(stub({:format => stub(:html? => bool), :GET => {} }))
  end
  def stub_lookup_context(result)
    @controller.stub!(:lookup_context).and_return(stub(:find_all => result))
  end
  before :each do
    @controller_class = Class.new
    @controller_class.stub!(:around_filter)
    @controller_class.stub!(:before_filter)
    @controller_class.stub!(:after_filter)
    @controller = @controller_class.new
    @controller.stub!(:params).and_return({})
    stub_request_format_html(false)
    @controller_class.send(:include, AjaxPagination::ControllerAdditions)
    @controller_class.send(:include, SetAjaxSection)
    @formatter = Class.new
    @formatter.stub!(:html).and_return(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15) # to detect how many times the function was called
    stub_lookup_context([]) # no partial matching
  end

  describe 'ajax_respond' do
    it 'should not render when section_id parameter not defined' do
      @controller.ajax_respond(@formatter).should be_false
      @controller.ajax_respond(@formatter, :section_id => :page).should be_false
      @controller.ajax_respond(@formatter, :section_id => 'page').should be_false
      @controller.ajax_respond(@formatter, :section_id => 'page2').should be_false
      @formatter.html.should == 0
    end
    it 'should render when section_id parameter matches' do
      stub_ajax_section('global')
      @controller.ajax_respond(@formatter).should be_true
      @formatter.html.should == 1 # detects html function was called once (but checking also calls the function) ...
      stub_ajax_section('page')
      @controller.ajax_respond(@formatter, :section_id => :page).should be_true
      @formatter.html.should == 3 # ... which is why the next check should be 2 more html function calls
      @controller.ajax_respond(@formatter, :section_id => 'page').should be_true
      @formatter.html.should == 5
      stub_ajax_section('pageX')
      @controller.ajax_respond(@formatter, :section_id => 'pageX').should be_true
      @formatter.html.should == 7
      stub_lookup_context(['matching_partial_found'])
      @controller.ajax_respond(@formatter, :section_id => 'pageX').should be_true
      @formatter.html.should == 9
      stub_ajax_section('global')
      @controller.ajax_respond(@formatter).should be_true
      @formatter.html.should == 11

    end
    it 'should not render when section_id parameter does not match' do
      stub_ajax_section('notpage')
      @controller.ajax_respond(@formatter).should be_false
      @controller.ajax_respond(@formatter, :section_id => :page).should be_false
      @controller.ajax_respond(@formatter, :section_id => 'page').should be_false
      stub_ajax_section('notpageX')
      @controller.ajax_respond(@formatter, :section_id => 'pageX').should be_false
      @formatter.html.should == 0
    end
  end

  describe 'ajax_section?' do
    it 'should display partial when format is not html' do
      @controller.ajax_section?.should be_true
    end
    it 'should display partial when format is html but section_id is not defined' do
      stub_request_format_html(true)
      @controller.ajax_section?.should be_true
    end
    it 'should display partial when .html?section_id=pagename' do
      stub_request_format_html(true)
      stub_ajax_section('global')
      @controller.ajax_section?.should be_true
      stub_ajax_section('page2')
      @controller.ajax_section?('page2').should be_true
      stub_ajax_section('page3')
      @controller.ajax_section?(:page3).should be_true
    end
    it 'should not display partial when .html?pagination!=pagename' do
      stub_request_format_html(true)
      stub_ajax_section('notpage')
      @controller.ajax_section?.should be_false
      stub_ajax_section('notpage2')
      @controller.ajax_section?('page2').should be_false
      stub_ajax_section('notpage3')
      @controller.ajax_section?(:page3).should be_false
    end
  end
end

