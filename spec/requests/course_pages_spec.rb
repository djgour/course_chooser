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
        before { click_link 'Edit' }
        it "should take the user to the edit page" do
          expect(page).to have_title('Edit #{course.code}: #{course.name}')
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