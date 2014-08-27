require 'rails_helper'

RSpec.describe "AuthenticationPages", :type => :request do
  subject { page }

  describe "sign in page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end

  describe "sign in" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title("Sign in") }
      it { should have_selector('div.alert.alert-error') }

      describe "after visiting another page" do
        before { click_link 'Course Chooser' }

        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email", with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_title(user.name) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      it { should_not have_content("Create an account") }

      describe "followed by sign out" do
        before { click_link 'Sign out' }
        it { should have_link('Sign in') }
      end

      describe "followed by visiting signin path" do
        before { visit signin_path }

        it { should_not have_button "Sign in" }
        it { should have_selector "div.alert-error" }
        it { should have_content "already signed in" }
      end
    end
  end

  describe "authorization" do
    describe "not being signed in" do
      let!(:user) { FactoryGirl.create(:user) }
      let!(:courseplan) { FactoryGirl.create(:courseplan, user_id: user.id) }

      describe "visiting a courseplan" do
        before { visit courseplan_path(courseplan) }
        it { should have_text("Please sign in.") }
        it { should_not have_text(courseplan.name) }
      end

      describe "visiting a user page" do
        before { visit user_path(user) }
        it { should have_text("Please sign in.") }
        it { should_not have_text(user.name) }
      end

      describe "submitting to the change_active_courseplan action" do
        before { patch change_active_courseplan_path(user) }
        specify { expect(response).to redirect_to(signin_path) }
      end

      describe "when visiting a protected page" do
        before do
          visit courseplan_path(courseplan)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in"

        it "should render the desired page" do
          expect(page).to have_title("CourseChooser | #{courseplan.name}")
        end
      end
    end

    describe "signed in as the wrong user" do
      let!(:user) { FactoryGirl.create(:user) }
      let!(:wrong_user) { FactoryGirl.create(:user, name: "Joe", email: "wrong@example.com") }
      let!(:courseplan) { FactoryGirl.create(:courseplan, user_id: wrong_user.id) }
      before do
        remember_token = User.new_remember_token
        cookies[:remember_token] = remember_token
        user.update_attribute(:remember_token, User.digest(remember_token))
      end

      describe "submitting a GET request to the Users#show action" do
        before { get user_path(wrong_user) }
        specify { expect(response.body).not_to match(wrong_user.name) }
        specify { expect(response).to redirect_to(root_url) }
      end
      
      describe "submitting a GET request to the Courseplans#show action" do
        before { get courseplan_path(courseplan) }
        specify { expect(response.body).not_to match(courseplan.name) }
        specify { expect(response.response_code).to eq 401 }
      end

      describe "submitting a PATCH request to the User#change_active_courseplan action" do
        before { patch change_active_courseplan_path(wrong_user) }
        specify { expect(response.response_code).to eq 401 }
      end

    end
    
    describe "attempting to create or edit a course page" do
      let!(:user) { FactoryGirl.create(:user) }
      let!(:admin_user) { FactoryGirl.create(:user, email: "admin@example.com", admin: true) }
      let!(:course) { FactoryGirl.create(:course) }
      
      describe "as a non-admin user" do
        before do
          remember_token = User.new_remember_token
          cookies[:remember_token] = remember_token
          user.update_attribute(:remember_token, User.digest(remember_token))
        end
        
        describe "submitting a GET request to the Courses#new action" do
          before { get new_course_path }
          specify { expect(response.response_code).to eq 401 } 
        end
        
        describe "submitting a POST request to the Courses#create action" do
          before { post courses_path }
          specify { expect(response.response_code).to eq 401 } 
        end
        
        describe "submitting a GET request to the Courses#edit action" do
          before { get edit_course_path(course) }
          specify { expect(response.response_code).to eq 401 } 
        end
        
        describe "submitting a PATCH request to the Courses#update action" do
          before { patch course_path(course) }
          specify { expect(response.response_code).to eq 401 }
        end
      end
    end
  end
end
