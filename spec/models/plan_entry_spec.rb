require 'rails_helper'

RSpec.describe PlanEntry, :type => :model do
  before do
    @course1 = Course.create(code: "BKS1001H", 
                            name: "Introduction to Book History", 
                     description: "A course about introducing book history.")
                     
    @course2 = Course.create(code: "BKS2001H", 
                           name: "Intermediate Book History", 
                    description: "A course about intermediate book history.")
    
    @course1 = Course.create(code: "BKS3001H", 
                            name: "Advanced Book History", 
                     description: "A course about advanced book history.")
    
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
  
end
