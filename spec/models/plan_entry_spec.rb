require 'rails_helper'

RSpec.describe PlanEntry, :type => :model do
  before do
    @course1 = Course.create(code: "RLS1001H", 
                             name: "Introduction to Ruby on Rails", 
                      description: "A course about introducing Ruby on Rails.")
                     
    @course2 = Course.create(code: "RLS2001H", 
                            name: "Intermediate Ruby on Rails", 
                     description: "A course about intermediate Ruby on Rails.")
    
    @course3 = Course.create(code: "RLS3001H", 
                             name: "Advanced Ruby on Rails", 
                      description: "A course about advanced Ruby on Rails.")
    
    @course4 = Course.create(code: "RLS3200H",
                             name: "Using Factories for Testing",
                      description: "How and why you should use factories when testing in Rails.")
    
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
  
  describe "semesters" do
    before do
      @plan_entry2 = PlanEntry.create(courseplan: @courseplan, course: @course2)
      @plan_entry3 = PlanEntry.create(courseplan: @courseplan, course: @course3)
      @plan_entry4 = PlanEntry.create(courseplan: @courseplan, course: @course4)
      @plan_entry.set_semester(year: 2012, season: :fall)
      @plan_entry2.set_semester(year: 2013, season: :winter)
      @plan_entry3.set_semester(year: 2013, season: :winter)
      @plan_entry4.no_semester!
    end
    
    it "should be able to set the semester of a plan entry" do    
      expect(@plan_entry.semester).to eq DateTime.new(2012, 9)
    end
    
    it "should nullify the semester with no_semester!" do
      @plan_entry.no_semester!
      expect(@plan_entry.semester).to eq nil
    end
    
    describe "courses_by_semester" do
      # Move to courseplan specs?
      it "should return a hash of courseplan course ids by semester" do
        expected_result = { :no_semester => [@plan_entry4],
                            :fall_2012 => [@plan_entry],
                            :winter_2013 => [@plan_entry2, @plan_entry3] }
      
        expect(@courseplan.courses_by_semester).to eq expected_result
        expect(@plan_entry.semester).to eq DateTime.new(2012, 9)
        expect(@plan_entry2.semester).to eq DateTime.new(2013, 1)
        expect(@plan_entry3.semester).to eq DateTime.new(2013, 1)
      end
      
      describe "no courses in courseplan" do
        before { @courseplan2 = Courseplan.create(user_id: @user.id, name: "Empty") }
        
        it "should return an empty hash if no courses are in it" do
          expect(@courseplan2.courses_by_semester).to be_empty
        end
      end
    end
  end
end
