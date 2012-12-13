include ApplicationHelper

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def valid_signup
  fill_in "Name",                   with: "Paul Bonneau"
  fill_in "Email",                  with: "thermaller@comcast.net"
  fill_in "Password",               with: "foobar"
  fill_in "Password confirmation",  with: "foobar"
end

def sign_in(user)
  visit signin_path
  valid_signin(user)
  
  #
  # Sign in when not using Capybara as well
  #
  cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-success', text: message)
  end
end

RSpec::Matchers.define :have_title do |title_text|
  match do |page|
    page.should have_selector('title', text: title_text)
  end
end

RSpec::Matchers.define :have_h1 do |title_text|
  match do |page|
    page.should have_selector('h1', text: title_text)
  end
end
