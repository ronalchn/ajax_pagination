require 'spec_helper'

describe 'rails3.0 support', :type => :request, :driver => :selenium do
  include Retryable
  it 'displays a loading image' do
    retry_exceptions do
      visit("http://#{SERVERIP}:#{R30SERVERPORT}") # goes to welcome page
      page.should have_no_selector('.ajaxpagination-loader')
      sleep(1.5)
      click_link 'About'
      page.should have_selector('.ajaxpagination-loader')
      sleep(1.5)
      page.should have_no_selector('.ajaxpagination-loader')
      click_link 'Readme'
      page.should have_selector('.ajaxpagination-loader')
      sleep(1.5)
      page.should have_no_selector('.ajaxpagination-loader')
      click_link 'Changelog'
      sleep(2)
      page.should have_selector('#changelogpagetitle')
      find('#page').find('.next_page').click
      page.should have_selector('.ajaxpagination-loader')
      sleep(1.5)
      page.should have_no_selector('.ajaxpagination-loader')
    end
  end
  it 'submits ajax_form_tag form via post' do
    visit("http://#{SERVERIP}:#{R30SERVERPORT}/pages/about")
    count = page.find("#submits").html.to_i
    click_button("Submit")
    sleep(1.5)
    page.should have_content("#{count+1} submit")
    page.should have_selector('#aboutpagetitle') # ensures loading was via AJAX Pagination
  end
end
