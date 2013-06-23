require 'spec_helper'

describe "UserPages" do

	subject { page }

  describe "GET /signup" do
  	before { get signup_path }

    it "should visit signup page" do
    	response.status.should be(200)
  	end
  end

  describe "Signup page" do
  	before { visit signup_path }

  	it { should have_selector('h1', text: "Sign up") }
  	it { should have_selector('title', text: full_title('Signup')) }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }

    before { visit user_path(user) }

    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }
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

        it { should have_selector("title", text: "Signup") }
        it { should have_content("error") }
        it { should have_content("Password") }
        it { should_not have_selector("li" , text: "Password digest can't be blank") }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Danish Satkut"
        fill_in "Email", with: "danish_satkut@hotmail.com"
        fill_in "Password", with: "foobarawesome"
        fill_in "Confirmation", with: "foobarawesome"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count)
      end

      describe "after saving the user" do
        before { click_button submit }

        let(:user) { User.where(:email => "danish_satkut@hotmail.com").first }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link("Sign out", href: signout_path) }
      end
    end
  end

  describe "profile update" do
    let(:user) { FactoryGirl.create(:user) }
    let(:submit) { "Save changes" }
    let(:update_h1_text) { 'Update your profile' }

    before { visit edit_user_path(user) }

    describe "page" do
      it { should have_selector('h1', :text => update_h1_text) }
      it { should have_selector('title', :text => 'Edit user') }
      it { should have_link('change', :href => 'http://en.gravatar.com/emails') }
    end

    describe "with invalid information" do
      it "should not update the user" do
        expect { click_button submit }.not_to change(user, :updated_at)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('h1', :text => update_h1_text) }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@email.com" }

      before(:each) do
        fill_in "Name", :with => new_name
        fill_in "Email", :with => new_email
        fill_in "Password", :with => user.password
        fill_in "Confirmation", :with => user.password

        click_button submit
      end

      it { should have_selector('title', :text => new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', :href => signout_path) }

      specify { user.reload.name = new_name }
      specify { user.reload.email = new_email }
    end
  end
end
