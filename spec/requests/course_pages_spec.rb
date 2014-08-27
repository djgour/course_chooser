require 'rails_helper'

RSpec.describe "CoursePages", :type => :request do
  
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  let(:course)  { FactoryGirl.create(:course) }
  let(:course2)  { FactoryGirl.create(:course) }
  let(:course3)  { FactoryGirl.create(:course) }
  
  before do
    visit root_path
    click_link 'Sign in'
    fill_in "Email",  with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
  
  describe "viewing a course" do
    before do
      course.save
      visit course_path(course) 
    end
    
    it { should have_title("CourseChooser | #{course.code}: #{course.name}") }
    it { should have_content(course.name) }
    it { should have_content(course.code) }
    it { should have_content(course.description) }
  end
  
  describe "New Course" do
    before { visit courses_path }
    it "should not be visible if you're not an admin user" do
      expect(page).not_to have_link('Add new course')
    end
    
    describe "when user is an admin" do
      before do
        user.toggle!(:admin)
        visit courses_path
      end
      
      it { should have_link('Add new course') }
      
      describe "using the new course link" do
        before do
          visit courses_path
          click_link 'Add new course'
        end
        
        it { should have_title("Add new course") }
        
        describe "Creating a course with invalid information" do
          it "should not add a course" do
            expect { click_button "Create" }.not_to change(Course, :count)
          end
          
          describe "after submission" do
            before { click_button "Create" }
          
            it { should have_content('errors') }
            it { should have_title("Add new course") }
          end
        end
        
        
        describe "Creating a course with valid information" do
          before do
            fill_in "Name", with: "A Brand New Course"
            fill_in "Code", with: "RLS4321H"
            fill_in "Description", with: "A course about how to create records in a table."
            fill_in "credits", with: 0.5
          end
          
          it "should add a new course" do
            expect { click_button "Create" }.to change(Course, :count).by(1)
          end
          
          describe "after saving a user" do
            before { click_button "Create" }
            it { should have_title("RLS4321H: A Brand New Course") }
            it { should have_content("successfully created") }
            it { should have_content("A course about how to create records in a table.") }
            it { should have_content("Credits: 0.5") }
          end
        end
      end
    end
  end
  
  describe "Edit Course" do
    before { visit course_path(course) }
    
    it { should_not have_link('Edit') } 
    
    describe "when user is an admin" do
      before do
        user.toggle!(:admin)
        visit course_path(course)
      end
      
      it { should have_link('Edit') }
      
      describe "using the Edit link" do
        before do
          visit course_path(course)
          click_link 'Edit' 
        end
        it { should have_title("Edit #{course.code}: #{course.name}") }
        
        describe "Editing a course with invalid information" do
          before do
            fill_in "Name", with: ""
            fill_in "Code", with: "RLS"
            fill_in "Description", with: ""
            fill_in "credits", with: ""
            click_button "Submit changes"
          end
          
          it { should have_content("errors") }
          it { should have_title("Edit RLS") }
        end
        
        describe "Editing a course with valid information" do
          before do
            fill_in "Name", with: "Off the Rails"
            fill_in "Code", with: "RLS9999Z"
            fill_in "Description", with: "Learn what happens when you edit courses using forms."
            fill_in "credits", with: 1.0
            click_button "Submit changes"
          end
          
          it { should have_content("Successfully updated!") }
          it { should have_title("CourseChooser | RLS9999Z: Off the Rails") }
          it { should have_content("Learn what happens when") }
          it { should have_content("Credits: 1.0") }
        end
      end
    end
  end
  
  
  describe "viewing all courses" do
    before do
      course2.update(code: "RLS5555H")
      course3.update(code: "RLS8888H")
      course.save
      visit courses_path
    end
     
     it { should have_content(course.code) }
     it { should have_content(course2.code) }
     it { should have_content(course3.code) }
     
     describe "visiting the main page" do
       before { visit root_url }
       
       it { should have_content(course.code) }
       it { should have_content(course2.code) }
       it { should have_content(course3.code) }
      
     end
  end
  
end