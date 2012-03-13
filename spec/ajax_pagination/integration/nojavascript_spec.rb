require 'spec_helper'

describe 'paginating without javascript', :type => :request, :driver => :rack_test do
  it 'still paginates' do
    visit(root_url) # goes to welcome page
    page.should have_selector('#welcomepagetitle')
    page.should have_no_selector('#aboutpagetitle')
    click_link 'About'
    page.should have_selector('#aboutpagetitle')
    page.should have_no_selector('#readmepagetitle')
    click_link 'Readme'
    page.should have_selector('#readmepagetitle')
    page.should have_no_selector('#aboutpagetitle')
  end
  it 'still paginates nested and multiple paginated sections' do
    visit(changelog_url)
    page.should have_selector('.previous_page.disabled')
    find('#page').find('.next_page').click
    page.should have_no_selector('.previous_page.disabled')
    find('#signin').click
    visit(posts_url)
    page.should have_selector('#upcomingpage .previous_page.disabled')
    find('#upcomingpage').find('.next_page').click
    page.should have_no_selector('#upcomingpage .previous_page.disabled')
    page.should have_selector('#page .previous_page.disabled')
    find('#page').find('.next_page').click
    page.should have_no_selector('#page .previous_page.disabled')
  end
end
