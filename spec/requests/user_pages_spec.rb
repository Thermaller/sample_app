require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_h1('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_h1(user.name) }
    it { should have_title(user.name) }
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

        it { should_not have_success_message('Welcome to the Sample App!') }
        it { should have_title('Sign up') }
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
      before { valid_signup }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_success_message('Welcome to the Sample App!') }
        it { should_not have_title 'Sign up' }
        it { should_not have_content('error') }
        it { should_not have_content("* Password can\'t be blank") }
        it { should_not have_content("* Name can\'t be blank") }
        it { should_not have_content(
          "* Password is too short (minimum is 6 characters)") }
        it { should_not have_content("* Password confirmation can't be blank") }
        it { should_not have_content("* Email can\'t be blank") }
        it { should_not have_content("* Email is invalid") }
        it { should have_link("Sign out") }
      end
    end
  end
end
