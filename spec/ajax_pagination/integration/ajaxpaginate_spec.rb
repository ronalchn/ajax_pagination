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
    find('#page_paginated_section').find('.next_page').click
    page.should have_selector('.ajaxloader')
    sleep(0.5)
    page.should have_no_selector('.ajaxloader')
    find('#upcomingpage_paginated_section').find('.next_page').click
    page.should have_selector('.ajaxloader')
    sleep(0.5)
    page.should have_no_selector('.ajaxloader')
  end
end
