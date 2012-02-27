require 'spec_helper'

describe 'paginating with javascript on', :js => true do
  it 'displays a loading image' do
    # following 3 lines to warm up loading image
    visit("http://localhost:#{SERVERPORT}") # goes to welcome page
    click_link 'Changelog'
    sleep(3)

    visit("http://localhost:#{SERVERPORT}") # goes to welcome page
    page.should have_no_selector('.ajaxpagination-loader')
    sleep(1)
    click_link 'About'
    page.should have_selector('.ajaxpagination-loader')
    sleep(1)
    page.should have_no_selector('.ajaxpagination-loader')
    click_link 'Readme'
    page.should have_selector('.ajaxpagination-loader')
    sleep(1)
    page.should have_no_selector('.ajaxpagination-loader')
  end
  it 'displays a loading image with nested and multiple paginated sections' do
    visit("http://localhost:#{SERVERPORT}/changelog")
    find('#_paginated_section').find('.next_page').click
    page.should have_selector('.ajaxpagination-loader')
    sleep(1)
    page.should have_no_selector('.ajaxpagination-loader')
    find('#signin').click
    visit("http://localhost:#{SERVERPORT}/posts")
    sleep(2)
    find('#page_paginated_section').find('.next_page').click
    page.should have_selector('.ajaxpagination-loader')
    sleep(1)
    page.should have_no_selector('.ajaxpagination-loader')
    find('#upcomingpage_paginated_section').find('.next_page').click
    page.should have_selector('.ajaxpagination-loader')
    sleep(1)
    page.should have_no_selector('.ajaxpagination-loader')
  end
  it 'shows the configured loading image' do
    visit("http://localhost:#{SERVERPORT}/changelog")
    find('#_paginated_section').find('.next_page').click
    page.should have_xpath("//img[@class='ajaxpagination-loader' and @src = '/assets/myajax-loader.gif']")
    sleep(1)
    visit("http://localhost:#{SERVERPORT}/posts")
    find('#_paginated_section').find('.next_page').click
    page.should have_xpath("//img[@class='ajaxpagination-loader' and @src = '/assets/ajax-loader.gif']")
  end
  it 'works with browser back and forward buttons' do
    visit("http://localhost:#{SERVERPORT}/changelog")
    find('#_paginated_section').find('.next_page').click
    sleep(1)
    click_link 'About'
    sleep(1)
    click_link 'Readme'
    sleep(2)
    page.should have_no_selector('.ajaxpagination-loader')
    page.should have_selector('#readmepagetitle')
    page.evaluate_script('window.history.back();') # back to About
    page.should have_selector('.ajaxpagination-loader')
    sleep(1)
    page.should have_no_selector('.ajaxpagination-loader')
    page.should have_selector('#aboutpagetitle')
    page.evaluate_script('window.history.forward();') # forward to readme
    sleep(1)
    page.should have_selector('#readmepagetitle')
    page.evaluate_script('window.history.go(-2);') # back to changelog page 2
    sleep(1)
    page.should have_no_selector('#aboutpagetitle')
    page.evaluate_script('window.history.forward();') # forward to about
    sleep(1)
    page.should have_selector('#aboutpagetitle')
  end
  it 'displays error pages within div' do
    visit("http://localhost:#{SERVERPORT}") # goes to welcome page
    click_link("AJAX Pagination Example Application")
    sleep(2)
    page.current_url.should == "http://localhost:#{SERVERPORT}/broken%20link"
    page.should have_content("AJAX Pagination Example Application")
    page.should have_content("No route matches")
  end
  it 'changes url to match redirection' do
    visit("http://localhost:#{SERVERPORT}")
    click_link("Posts")
    sleep(1)
    page.should have_content("New Post")
    myurl = page.current_url # to get the canonical url
    click_link("New Post")
    sleep(2)
    page.should have_content("Access Denied")
    page.current_url.should == myurl
  end
  it 'submits ajax_form_tag form via post' do
    visit("http://localhost:#{SERVERPORT}/pages/about")
    count = page.find("#submits").html.to_i
    click_button("Submit")
    sleep(1)
    page.should have_content("#{count+1} submit")
    page.should have_selector('#aboutpagetitle') # ensures loading was via AJAX Pagination
  end
  it 'history does not change if :history => false' do
    visit("http://localhost:#{SERVERPORT}/pages/about")
    myurl = page.current_url # to get the canonical url
    count = page.find("#submits").html.to_i
    click_button("Submit")
    sleep(1)
    page.should have_content("#{count+1} submit")
    page.current_url.should == myurl # url remains the same (so history has not changed)
  end
  it 'submits ajax_form_for form via POST and PUT and DELETE link' do
    visit("http://localhost:#{SERVERPORT}")
    find('#signin').click
    click_link("Posts")
    sleep(1)
    page.should have_content("New Post")
    myurl = page.current_url # to get the canonical url
    visit("http://localhost:#{SERVERPORT}/posts/new")
    within("#new_post") do
      fill_in 'Title', :with => 'very unique title for test'
      fill_in 'Content', :with => 'my supercontent'
    end
    click_button("Create Post");
    page.should have_selector('.ajaxpagination-loader')
    sleep(2)
    page.should have_content("Post was successfully created.")
    page.current_url.should_not == myurl # means we have gotten redirected
    click_link("Edit");
    within(".edit_post") do
      fill_in 'Content', :with => 'my supercontent again'
    end
    click_button("Update Post");
    page.should have_selector('.ajaxpagination-loader')
    sleep(2)
    page.should have_content("my supercontent again")
    click_link("Destroy");
    page.driver.browser.switch_to.alert.accept
    page.should have_selector('.ajaxpagination-loader')
    sleep(2)
    page.should have_content("Post destroyed.")
  end
  it 'changes title' do
    visit("http://localhost:#{SERVERPORT}")
    title = page.evaluate_script("document.title") # because what is between the <title> tags and what is shown in the window title can differ (document.title gets set by javascript)
    click_link("About");
    sleep(1)
    page.should have_selector('#aboutpagetitle') # ensures loading was via AJAX Pagination
    page.evaluate_script("document.title").should_not == title
  end
end
