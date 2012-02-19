require "spec_helper"

describe AjaxPagination::ControllerAdditions do
  def stub_paginate(name)
    @controller.stub!(:params).and_return({:paginate => name})
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
  end

  describe 'ajax_pagination_displayed?' do
    it 'should display partial when format is not js' do
      @controller.ajax_pagination_displayed?.should be_true
    end

    it 'should display partial when format is js but paginate is not defined' do
      stub_request_format_js(true)
      @controller.ajax_pagination_displayed?.should be_true
    end

    it 'should display partial when .js?paginate=pagename' do
      stub_request_format_js(true)
      stub_paginate('page')
      @controller.ajax_pagination_displayed?.should be_true
      stub_paginate('page2')
      @controller.ajax_pagination_displayed?('page2').should be_true
      stub_paginate('page3')
      @controller.ajax_pagination_displayed?(:page3).should be_true
    end

    it 'should not display partial when .js?paginate!=pagename' do
      stub_request_format_js(true)
      stub_paginate('notpage')
      @controller.ajax_pagination_displayed?.should be_true
      stub_paginate('notpage2')
      @controller.ajax_pagination_displayed?('page2').should be_true
      stub_paginate('notpage3')
      @controller.ajax_pagination_displayed?(:page3).should be_true
    end
  end
end

