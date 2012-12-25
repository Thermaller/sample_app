require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_h1(heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title '| Home' }
    it { should have_link("Sign up now!") }

    describe "after sign in" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        sign_in(user)
        click_link("Home")
      end
   
      it { should_not have_link("Sign up now!") }
    end

    describe "feed for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        50.times do |i|
          FactoryGirl.create(:micropost, { user: user, content: "mp #{i}" })
        end
        sign_in user
        visit root_path
      end
      let (:cmp) { user.feed.count }
      let (:strcmp) { cmp == 0 || cmp > 1 ? "microposts" : "micropost" }
      let (:str) { "#{cmp} #{strcmp}" }
      after(:all)  { user.feed.delete_all }

      it "should have pagination" do
        page.should have_selector('div.pagination')
      end

      it "should render the user's feed" do
        user.feed.paginate(page: 1).each do |mp|
          page.should have_selector("li##{mp.id}", text: mp.content)
          if mp.user_id == user.user_id
            page.should_not have_link("delete")
          else
            page.should have_link("delete")
          end
        end
      end

      it "should show the correct number of microposts" do
        page.should have_selector("span", text: str)
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading) { 'About' }
    let(:page_title) { 'About Us' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_title full_title('About Us')

    click_link "Help"
    page.should have_title full_title('Help')

    click_link "Contact"
    page.should have_title full_title('Contact')

    click_link("Home")
    click_link("Sign up now!")
    page.should have_title full_title('Sign up')

    click_link("sample app")
    page.should have_title full_title('')
  end
end
