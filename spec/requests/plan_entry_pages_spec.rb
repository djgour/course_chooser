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
                
  Course.create(name: "Factories",
                code: "RLS3013H",
                description: "Learn how to make your tests much easier.")

  before do
    @course1 = Course.first
    @course2 = Course.second
    @course3 = Course.third
    @course4 = Course.fourth
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
        expect { first(:link, "+").click }.to change(user.active_courseplan.courses, :count).by(1)
      end
      
      describe "semesters" do
        before do
          plan = user.courseplans.first
          plan.add_course!(@course1)
          plan.add_course!(@course2)
          plan.add_course!(@course3)
          plan.add_course!(@course4)
          plan.plan_entries.find_by(course_id: @course1.id).set_semester(year: 2014, season: :winter)      
          plan.plan_entries.find_by(course_id: @course2.id).set_semester(year: 2013, season: :fall) 
          plan.plan_entries.find_by(course_id: @course4.id).set_semester(year: 2014, season: :winter)
          visit courseplan_path(plan)   
        end
        
        it { should have_text('Fall 2013') }
        it { should have_text('Winter 2014') }
        describe "forms for changing semesters" do
          pending
        end
      end
    end   
  end
end
