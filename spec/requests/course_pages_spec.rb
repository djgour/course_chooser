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
  
  describe "the edit link" do
    before { visit course_path(course) }
    it "should not be visible if you're not an admin user" do
      expect(page).not_to have_link('Edit')
    end
    
    describe "when user is an admin" do
      before do
        user.toggle!(:admin)
        visit course_path(course)
      end
      
      it "should be visible" do
        expect(page).to have_link('Edit')
      end
      
      describe "using the Edit link" do
        before do
          visit course_path(course)
          click_link 'Edit' 
        end
        it { should have_title("Edit #{course.code}: #{course.name}") }
        
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