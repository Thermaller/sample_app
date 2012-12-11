require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1',     text: user.name) }
    it { should have_selector('title',  text: user.name) }
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should_not have_selector('div', text: 'Welcome to the Sample App!') }
        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
        it { should have_content("* Password can\'t be blank") }
        it { should have_content("* Name can\'t be blank") }
        it { should have_content(
          "* Password is too short (minimum is 6 characters)") }
        it { should have_content("* Password confirmation can't be blank") }
        it { should have_content("* Email can\'t be blank") }
        it { should have_content("* Email is invalid") }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",                   with: "Paul Bonneau"
        fill_in "Email",                  with: "thermaller@comcast.net"
        fill_in "Password",               with: "foobar"
        fill_in "Password confirmation",  with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('div', text: 'Welcome to the Sample App!') }
        it { should_not have_selector('title', text: 'Sign up') }
        it { should_not have_content('error') }
        it { should_not have_content("* Password can\'t be blank") }
        it { should_not have_content("* Name can\'t be blank") }
        it { should_not have_content(
          "* Password is too short (minimum is 6 characters)") }
        it { should_not have_content("* Password confirmation can't be blank") }
        it { should_not have_content("* Email can\'t be blank") }
        it { should_not have_content("* Email is invalid") }
      end
    end
  end
end