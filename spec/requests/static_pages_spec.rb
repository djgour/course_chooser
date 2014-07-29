require 'rails_helper'

RSpec.describe "StaticPages", :type => :request do
  describe "Static pages" do

    subject { page }

    describe "Home Page" do
      before { visit root_path }

      describe "when not signed in" do
        before { click_link 'Sign in' }

        it { should have_content('Sign in') }
        it { should have_title('Sign in') }
      end
      
    end
  end
end
