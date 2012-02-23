require 'spec_helper'

describe 'paginating with javascript on', :js => true do
  it 'displays a loading image' do
    visit("http://localhost:#{SERVERPORT}") # goes to welcome page
    page.should have_no_selector('.ajaxloader')
    click_link 'About'
    page.should have_selector('.ajaxloader')
    sleep(0.5)
    page.should have_no_selector('.ajaxloader')
    click_link 'Readme'
    page.should have_selector('.ajaxloader')
    sleep(0.5)
    page.should have_no_selector('.ajaxloader')
  end
  it 'displays a loading image with nested and multiple paginated sections' do
    visit("http://localhost:#{SERVERPORT}/changelog")
    find('#page_paginated_section').find('.next_page').click
    page.should have_selector('.ajaxloader')
    sleep(0.5)
    page.should have_no_selector('.ajaxloader')
    find('#signin').click
    visit("http://localhost:#{SERVERPORT}/posts")
    sleep(2)
    find('#page_paginated_section').find('.next_page').click
    page.should have_selector('.ajaxloader')
    sleep(0.5)
    page.should have_no_selector('.ajaxloader')
    find('#upcomingpage_paginated_section').find('.next_page').click
    page.should have_selector('.ajaxloader')
    sleep(0.5)
    page.should have_no_selector('.ajaxloader')
  end
  it 'shows the configured loading image' do
    visit("http://localhost:#{SERVERPORT}/changelog")
    find('#page_paginated_section').find('.next_page').click
    page.should have_xpath("//img[@class='ajaxloader' and @src = '/assets/myajax-loader.gif']")
  end
  it 'works with browser back and forward buttons' do
    visit("http://localhost:#{SERVERPORT}/changelog")
    find('#page_paginated_section').find('.next_page').click
    sleep(0.5)
    click_link 'About'
    sleep(0.5)
    click_link 'Readme'
    sleep(2)
    page.should have_no_selector('.ajaxloader')
    page.should have_selector('#readmepagetitle')
    page.evaluate_script('window.history.back();') # back to About
    page.should have_selector('.ajaxloader')
    sleep(0.5)
    page.should have_no_selector('.ajaxloader')
    page.should have_selector('#aboutpagetitle')
    page.evaluate_script('window.history.forward();') # forward to readme
    sleep(0.5)
    page.should have_selector('#readmepagetitle')
    page.evaluate_script('window.history.go(-2);') # back to changelog page 2
    sleep(0.5)
    page.should have_no_selector('#aboutpagetitle')
    page.evaluate_script('window.history.forward();') # forward to about
    sleep(0.5)
    page.should have_selector('#aboutpagetitle')
  end
end
