require 'rails_helper'

RSpec.describe Course, :type => :model do
  before do
    @course = Course.create(code: "BKS1001H", 
                            name: "Introduction to Book History", 
                     description: "A course about introducing book history.")
  end
  
  subject { @course }
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:code) }
  
  describe "when the course code is too short" do
    before { @course.update(code: "BKS1000") }
    it { should_not be_valid }
  end
  
  describe "when the course code is too long" do
    before { @course.update(code: "BKS1001HY") }
    it { should_not be_valid }
  end
  
  describe "when the description is too short" do
    before { @course.update(description: "Hi") }
    it { should_not be_valid }
  end
  
  describe "when the name is missing" do
    before { @course.update(name: "") }
    it { should_not be_valid }
  end
end
