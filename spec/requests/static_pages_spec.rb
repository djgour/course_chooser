require 'rails_helper'

RSpec.describe "StaticPages", :type => :request do
  describe "Static pages" do

    subject { page }

    describe "Home Page" do
      before { visit root_path }

      it { should have_content('Home') }
      
    end
  end
end
