require 'spec_helper'

describe 'paginating with javascript on', :type => :request, :driver => :selenium, :js => true do
  it 'works' do
    visit("http://#{SERVERIP}:#{SERVERPORT}") # goes to welcome page
    page.should have_no_selector('#aboutpagetitle')
    click_link 'About'
    page.should have_selector('#aboutpagetitle')
    page.should have_no_selector('#readmepagetitle')
    click_link 'Readme'
    page.should have_selector('#readmepagetitle')
    page.should have_no_selector('#aboutpagetitle')
  end
  it 'works with nested and multiple paginated sections' do
    visit("http://#{SERVERIP}:#{SERVERPORT}/changelog")
    page.should have_selector('.previous_page.disabled')
    find('#page').find('.next_page').click
    page.should have_no_selector('.previous_page.disabled')
    find('#signin').click
    visit("http://#{SERVERIP}:#{SERVERPORT}/posts")
    page.should have_selector('#page .previous_page.disabled')
    find('#page').find('.next_page').click
    sleep(1)
    page.should have_no_selector('#page .previous_page.disabled')
    page.should have_selector('#upcomingpage .previous_page.disabled')
    find('#upcomingpage').find('.next_page').click
    sleep(1)
    page.should have_no_selector('#upcomingpage .previous_page.disabled')
    page.should have_no_selector('#page .previous_page.disabled')
  end
end
