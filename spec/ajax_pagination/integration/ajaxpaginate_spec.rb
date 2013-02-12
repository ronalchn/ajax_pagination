require 'spec_helper'

describe 'paginating with javascript on', :js => true do
  include Retryable

  def ajaxCount
    page.evaluate_script("document.getElementById('countajaxloading').innerHTML").to_i # using javascript to get content because selenium cannot get content of non-visible elements
  end

  it 'displays a loading image' do
    retry_exceptions do
      # following lines to warm up loading image
      visit("http://#{SERVERIP}:#{SERVERSLOWPORT}") # goes to welcome page
      sleep(3)
      click_link 'Changelog'
      sleep(3)

      visit("http://#{SERVERIP}:#{SERVERSLOWPORT}") # goes to welcome page
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
    end
  end
  it 'displays a loading image with nested and multiple paginated sections' do
    retry_exceptions do
      # following lines to warm up
      visit("http://#{SERVERIP}:#{SERVERSLOWPORT}") # goes to welcome page
      sleep(3)
      click_link 'Changelog'
      sleep(3)

      visit("http://#{SERVERIP}:#{SERVERSLOWPORT}/changelog")
      sleep(2)
      page.should have_selector('#changelogpagetitle')
      find('#page').find('.next_page').click
      page.should have_selector('.ajaxpagination-loader')
      sleep(1.5)
      page.should have_no_selector('.ajaxpagination-loader')
    end
    retry_exceptions(10) do |i| # has trouble finding sign-in link (rbx slow? or ...?)
      sleep(2)
      case i%4
      when 0
        visit("http://#{SERVERIP}:#{SERVERSLOWPORT}") # goes to welcome page
      when 1
        visit("http://#{SERVERIP}:#{SERVERSLOWPORT}/pages/about") # goes to welcome page
      when 2
        visit("http://#{SERVERIP}:#{SERVERSLOWPORT}/changelog") # goes to welcome page
      when 3
        visit("http://#{SERVERIP}:#{SERVERSLOWPORT}/posts") # goes to welcome page
      end
      find('#signin').click
      sleep(2)
    end
    retry_exceptions do
      visit("http://#{SERVERIP}:#{SERVERSLOWPORT}/posts")
      sleep(2)
      page.should have_selector('#postspagetitle')
      find('#page').find('.next_page').click
      sleep(0.5) # failed once on travis rbx without sleep
      page.should have_selector('.ajaxpagination-loader')
      sleep(1.5)
      page.should have_no_selector('.ajaxpagination-loader')
      find('#upcomingpage').find('.next_page').click
      page.should have_selector('.ajaxpagination-loader')
      sleep(1.5)
      page.should have_no_selector('.ajaxpagination-loader')
    end
  end
  it 'shows the configured loading image' do
    retry_exceptions do
      # warmup images
      visit("http://#{SERVERIP}:#{SERVERSLOWPORT}/changelog")
      find('#page').find('.next_page').click
      sleep(3)
      visit("http://#{SERVERIP}:#{SERVERSLOWPORT}/posts")
      find('#page').find('.next_page').click
      sleep(3)

      visit("http://#{SERVERIP}:#{SERVERSLOWPORT}/changelog")
      find('#page').find('.next_page').click
      page.should have_xpath("//img[@class='ajaxpagination-loader' and @src = '/assets/myajax-loader.gif']")
      sleep(1.5)
      visit("http://#{SERVERIP}:#{SERVERSLOWPORT}/posts")
      find('#page').find('.next_page').click
      page.should have_xpath("//img[@class='ajaxpagination-loader' and @src = '/assets/ajax-loader.gif']")
    end
  end
  it 'works with browser back and forward buttons' do
    visit("http://#{SERVERIP}:#{SERVERPORT}/pages/about") # warmup serverport
    sleep(3)
    page.should have_selector('#aboutpagetitle')

    # actual test
    visit("http://#{SERVERIP}:#{SERVERPORT}/changelog")
    sleep(1)
    page.should have_selector('#changelogpagetitle')
    click_link 'About'
    sleep(1)
    page.should have_selector('#aboutpagetitle')
    click_link 'Readme'
    sleep(1)
    page.should have_selector('#readmepagetitle')
    count = ajaxCount
    page.evaluate_script('window.history.back();') # back to About
    page.should have_selector('#aboutpagetitle')
    ajaxCount.should == count + 1
    page.evaluate_script('window.history.forward();') # forward to readme
    page.should have_selector('#readmepagetitle')
    page.evaluate_script('window.history.go(-2);') # back to changelog
    page.should have_no_selector('#aboutpagetitle')
    page.evaluate_script('window.history.forward();') # forward to about
    page.should have_selector('#aboutpagetitle')
  end
  it 'has correct reload behaviour on history' do
    visit("http://#{SERVERIP}:#{SERVERPORT}/pages/about")
    sleep(3) # rbx has long warmup time
    page.should have_selector('#aboutpagetitle')
    click_link 'Readme' # History will have [about,readme]
    sleep(1)
    page.should have_selector('#readmepagetitle')
    click_link 'Readme' # should not add readme to history again - behaviour should be like a page refresh
    sleep(0.5)
    page.should have_no_selector('.ajaxpagination-loader')
    page.evaluate_script('window.history.back();') # back to About (if readme not added to history twice)
    page.should have_selector('#aboutpagetitle')
  end
  it 'has correct reload behaviour when jumping between history with the same url' do
    visit("http://#{SERVERIP}:#{SERVERPORT}/pages/about")
    sleep(3) # allow warmup time (zzz... rbx)
    page.should have_selector('#aboutpagetitle')
    click_link 'Readme' # History will have [about,readme]
    sleep(1)
    page.should have_selector('#readmepagetitle')
    click_link 'About' # History will have [about,readme,about]
    sleep(1)
    page.should have_selector('#aboutpagetitle')
    find("#aboutpagetitle").text.should_not == "ReloadReferenceToken"
    page.evaluate_script('document.getElementById("aboutpagetitle").innerHTML = "ReloadReferenceToken";') # allows us to tell if it got reloaded
    find("#aboutpagetitle").text.should == "ReloadReferenceToken"
    page.evaluate_script('window.history.go(-2);') # back from about page to about page again

    sleep(1)
    find("#aboutpagetitle").text.should == "ReloadReferenceToken" # hasn't reloaded if token is still there
  end
  it 'displays error pages within div' do
    visit("http://#{SERVERIP}:#{SERVERPORT}") # goes to welcome page
    sleep(1)
    click_link("AJAX Pagination Example Application")
    page.current_url.should == "http://#{SERVERIP}:#{SERVERPORT}/broken%20link"
    page.should have_content("AJAX Pagination Example Application")
    page.should have_content("No route matches")
  end
  it 'changes url to match redirection' do
    visit("http://#{SERVERIP}:#{SERVERPORT}")
    sleep(1)
    click_link("Posts")
    sleep(1)
    page.should have_content("New Post")
    myurl = page.current_url # to get the canonical url
    click_link("New Post")
    page.should have_content("Access Denied")
    page.current_url.should == myurl
  end
  it 'submits ajax_form_tag form via post' do
    visit("http://#{SERVERIP}:#{SERVERPORT}/pages/about")
    count = page.find("#submits").html.to_i
    click_button("Submit")
    page.should have_content("#{count+1} submit")
    page.should have_selector('#aboutpagetitle') # ensures loading was via AJAX Pagination
  end
  it 'history does not change if :history => false' do
    visit("http://#{SERVERIP}:#{SERVERPORT}/pages/about")
    myurl = page.current_url # to get the canonical url
    count = page.find("#submits").html.to_i
    click_button("Submit")
    page.should have_content("#{count+1} submit")
    page.current_url.should == myurl # url remains the same (so history has not changed)
  end
  it 'submits ajax_form_for form via POST and DELETE link' do
    retry_exceptions do
      visit("http://#{SERVERIP}:#{SERVERPORT}/")
      find('#signin').click if !page.has_selector?('#signout')
      click_link("Posts")
      sleep(1)
      page.should have_content("New Post")
      myurl = page.current_url # to get the canonical url
      visit("http://#{SERVERIP}:#{SERVERPORT}/posts/new")
      sleep(1)
      within("#new_post") do
        fill_in 'Title', :with => 'very unique title for test'
        fill_in 'Content', :with => 'my supercontent'
      end
      count = ajaxCount
      click_button("Create Post");
      sleep(2)
      page.should have_content("Post was successfully created.")
      ajaxCount.should == count + 1
      page.current_url.should_not == myurl # means we have gotten redirected

      count = ajaxCount
      click_link("Destroy");
      sleep(2)
      page.driver.browser.switch_to.alert.accept
      sleep(2)
      page.should have_content("Post destroyed.")
      ajaxCount.should == count + 1
    end
  end
  # This spec does not work in rbx on travis.
  # Tested to work in rbx-1.2.4 on local machine. Also works using MRI ruby on travis.
  it 'submits ajax_form_for form via PUT link' do
    retry_exceptions do
      visit("http://#{SERVERIP}:#{SERVERPORT}")
      find('#signin').click
      sleep(2)
      visit("http://#{SERVERIP}:#{SERVERPORT}/posts/2")
      click_link("Edit");
      sleep(2)
      within(".edit_post") do
        fill_in 'Content', :with => 'some supercontent'
      end
      count = ajaxCount
      click_button("Update Post");
      sleep(3)
      # page.should have_content("Post was successfully updated.") # does not work in rbx on travis (????)
      page.should have_content("some supercontent")
      ajaxCount.should == count + 1
    end
  end
  it 'changes title' do
    retry_exceptions do
      visit("http://#{SERVERIP}:#{SERVERPORT}")
      title = page.evaluate_script("document.title") # because what is between the <title> tags and what is shown in the window title can differ (document.title gets set by javascript)
      click_link("About");
      page.should have_selector('#aboutpagetitle') # ensures loading was via AJAX Pagination
      page.evaluate_script("document.title").should_not == title
    end
  end
end
