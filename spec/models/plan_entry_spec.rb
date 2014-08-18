require 'rails_helper'

RSpec.describe PlanEntry, :type => :model do
  before do
    @course1 = Course.create(code: "RLS1001H", 
                            name: "Introduction to Ruby on Rails", 
                     description: "A course about introducing Ruby on Rails.")
                     
    @course2 = Course.create(code: "RLS2001H", 
                           name: "Intermediate Ruby on Rails", 
                    description: "A course about intermediate Ruby on Rails.")
    
    @course1 = Course.create(code: "RLS3001H", 
                            name: "Advanced Ruby on Rails", 
                     description: "A course about advanced Ruby on Rails.")
    
     @user = User.create(name: "Example User", email: "user@example.com",
                         password: "foobar", password_confirmation: "foobar") 
     
     @courseplan = Courseplan.create(user_id: @user.id, name: "Default")
     
     @plan_entry = PlanEntry.create(courseplan: @courseplan, course: @course1)
  end
  
  subject { @plan_entry }
  
  it { should respond_to(:courseplan_id) }
  it { should respond_to(:course_id) }
  it { should respond_to(:semester) }
  
  describe "duplicate courses in a courseplan" do
    before do
      @duplicate_entry = PlanEntry.create(courseplan: @courseplan,
                                          course: @course2)
      @plan_entry.update(course: @course2)
    end
    
    it { should_not be_valid }                             
  end
  
  describe "different courseplans to have the same course" do
    before do
      @courseplan2 = Courseplan.create(user: @user, name: "Alternate")
      @plan_entry2 = PlanEntry.create(courseplan: @courseplan2,
                                      course: @course2)
      @plan_entry.update(course: @course2)
    end
    
    it { should be_valid }
  end
  
  describe "deleting the course plan" do
    before do
      @plan_id = @plan_entry.id
      @course_id = @plan_entry.course_id
      @courseplan.destroy
    end

    it "should destroy the plan entry but not the course" do
      expect(PlanEntry.find_by(id: @plan_id)).to be_nil
      expect(Course.find_by(id: @course_id)).to_not be_nil 
    end
  end

end
