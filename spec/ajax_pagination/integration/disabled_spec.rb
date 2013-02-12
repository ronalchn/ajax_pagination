require 'spec_helper'

describe 'disabled with javascript', :js => true do
  before :each do
    visit("http://#{SERVERIP}:#{SERVERPORT}/pages/warnings")
    find("#disablehistoryjslink").click
    page.driver.browser.switch_to.alert.accept
  end
  it 'link within action still works' do
    find("#fullpagelink").click
    page.should have_content("You are on page 2")
  end

  it 'site navigation still works' do
    click_link("Readme")
    page.should have_selector('#readmepagetitle')
  end
end
