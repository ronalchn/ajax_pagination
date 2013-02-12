require 'spec_helper'

describe 'javascript warnings', :js => true do
  it 'warns about excess page content' do
    visit("http://#{SERVERIP}:#{SERVERPORT}/pages/warnings")
    find("#fullpagelink").click
    sleep(0.5)
    alertmsg = page.driver.browser.switch_to.alert.text
    alertmsg.should include("EXTRA_CONTENT_DISCARDED")
    page.driver.browser.switch_to.alert.accept
    page.should have_content("You are on page 2")
  end

  it 'warns about missing dependencies' do
    visit("http://#{SERVERIP}:#{SERVERPORT}/pages/warnings")
    find("#disablehistoryjslink").click
    sleep(0.5)
    alertmsg = page.driver.browser.switch_to.alert.text
    alertmsg.should include("MISSING_DEPENDENCIES")
    page.driver.browser.switch_to.alert.accept
    page.should have_content("Disabled")
  end

  it 'warns about reference to more than one section of same id' do
    visit("http://#{SERVERIP}:#{SERVERPORT}/pages/warnings")
    find("#doublesectionlink").click
    alertmsg = page.driver.browser.switch_to.alert.text
    alertmsg.should include("UNIQUE_SECTION_NOT_FOUND")
    page.driver.browser.switch_to.alert.accept
  end

  it 'warns about reference to section which does not exist' do
    visit("http://#{SERVERIP}:#{SERVERPORT}/pages/warnings")
    find("#nosectionlink").click
    alertmsg = page.driver.browser.switch_to.alert.text
    alertmsg.should include("UNIQUE_SECTION_NOT_FOUND")
    page.driver.browser.switch_to.alert.accept
  end
end
