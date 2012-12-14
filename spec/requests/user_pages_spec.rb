require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_title("All users") }
    it { should have_h1("All users") }

    it "should list each user" do
      User.all.each do |u|
        page.should have_selector("li", text: u.name)
      end
    end
  end

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

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_h1("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link("change", href: "http://gravatar.com/emails") }
    end

    describe "with invalid credentials" do
      before { click_button "Save changes" }

      it { should have_content("error") }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm password", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_success_message }
      it { should have_link("Sign out", href: signout_path) }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end
end
