require 'rails_helper'

RSpec.describe "CourseplanPages", :type => :request do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:submit) { "Sign in" }
        
  before do
    visit root_path
    click_link 'Sign in'
    fill_in "Email",  with: user.email
    fill_in "Password", with: user.password
    click_button submit
  end

  describe "courseplan creation" do
    before { visit new_courseplan_path }

    it { should have_content("Create new courseplan") }

    describe "with invalid information" do
      before { click_button "Create" }

      it { should have_content("Name can't be blank") }
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Default"
        click_button "Create"
      end

      it { should have_content('New plan created!') }
      it { should have_content('Default') }
      describe "when a second courseplan is created" do
        before do
          visit new_courseplan_path
          fill_in "Name", with: "Alternate"
          click_button "Create"
        end
        it { should have_content('New plan created!') }
        it { should have_content "Alternate" }
        it { should have_link "Alternate" } 
        describe "the non-default courseplan" do
          before do
            click_link "Alternate"
          end
          it { should have_link("Set as active courseplan") }

          describe "when the set as default link is clicked" do
            before do
              click_link "Set as active courseplan"
              visit root_path
            end
            it { should have_selector("h2", text: "Alternate") }
          end
        end
      end
    end
  end

end