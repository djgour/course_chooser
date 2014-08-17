require 'rails_helper'

RSpec.describe "PlanEntryPages", :type => :request do
  
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  
  Course.create(name: "Intro to Rails",
                code: "RLS1000H",
                description: "An introduction to Ruby on Rails")

  Course.create(name: "Intermediate Rails",
                code: "RLS2000H",
                description: "Dive even deeper into Rails.")

  Course.create(name: "Advanced Rails",
                code: "RLS3000H",
                description: "Become a pro in Ruby on Rails.")

  before do
    @course1 = Course.first
    @course2 = Course.second
    @course3 = Course.third
    sign_in user
  end
  
  describe "adding courses" do
    before { visit root_url }
    
    describe "with no courseplans" do
      it { should_not have_link "-"}
      it { should_not have_link "+" }
      it { should have_content @course1.name }
      
      it "should have courses" do
        expect(Course.all.count).not_to eq 0
      end
    end
    
    describe "with a courseplan" do
      before do
        click_link "Create course plan"
        fill_in "Name", with: "Default"
        click_button "Create"
      end
    
      it { should_not have_link "-"}
      it { should have_link "+" }
      it { should have_text "#{@course1.name} +" }
      it "should increase the courseplan's course count by 1" do
        expect { first(:link, "+").click }.to change(user.default_courseplan.courses, :count).by(1)
      end
    end
  end
end
