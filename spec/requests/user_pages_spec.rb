require 'rails_helper'

RSpec.describe "UserPages", :type => :request do
  
  subject { page }

  describe "registration page" do
    before { visit register_path }

    it { should have_title("Register") }
    it { should have_content("Register for Course Chooser") }
  end
end
