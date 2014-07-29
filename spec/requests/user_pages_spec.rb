require 'rails_helper'

RSpec.describe "UserPages", :type => :request do
  
  subject { page }

  describe "registration page" do
    before { visit register_path }

    it { should have_title("Register") }
    it { should have_content("Register") }
  end

  describe "registration" do
    before { visit register_path }

    let(:submit) { "Create account" }

    describe "with valid information" do
      before do
        fill_in "Name",       with: "Test User"
        fill_in "Email",      with: "test@example.com"
        fill_in "Password",   with: "foobar"
        fill_in "Confirm your password",  with: "foobar"
      end

      it "should create a new user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after submission" do
        before { click_button submit }

        it {should have_content("Successfully registered!")}
      end
    end

    describe "with invalid information" do
      before do
        visit register_path
        click_button submit
      end
        it { should have_content("Name can't be blank") }
        it { should have_content("Email can't be blank") }
        it { should have_content("Email is invalid") }
        it { should have_content("Password can't be blank") }
        it { should have_content("Password is too short") }
    end
  end
end

