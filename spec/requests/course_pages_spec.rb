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
  
  describe "viewing all courses" do
    before do
      course2.update(code: "INF5555H")
      course3.update(code: "INF8888H")
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