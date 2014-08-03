require 'rails_helper'

RSpec.describe "StaticPages", :type => :request do
  describe "Static pages" do

    subject { page }

    describe "Home Page" do
      before { visit root_path }

      describe "when not signed in" do
        before { click_link 'Sign in' }

        it { should have_button('Sign in') }
        it { should have_title('Sign in') }
      end

      describe "when signed in" do
        let(:user) { FactoryGirl.create(:user) }
        let(:submit) { "Sign in" }
        
        before do
          visit root_path
          click_link 'Sign in'
          fill_in "Email",  with: user.email
          fill_in "Password", with: user.password
          click_button submit
        end

        describe "New user with no courseplans" do
          it { should have_content("no course plans.") }
          it { should have_link "Create course plan" }
        end
      end  
    end
  end
end
