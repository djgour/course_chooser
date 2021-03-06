require 'rails_helper'

RSpec.describe Course, :type => :model do
  before do
    @course = Course.create(code: "HIS1001H", 
                            name: "Introduction to History", 
                     description: "A course about introducing history.")
  end
  
  subject { @course }
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:code) }
  it { should respond_to(:credits) } 
  
  describe "when the course code is too short" do
    before { @course.update(code: "HIS1000") }
    it { should_not be_valid }
  end
  
  describe "when the course code is too long" do
    before { @course.update(code: "HIS1001HY") }
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
  
  describe "credits" do
    before { @course.update(credits: 50) }
    it "should return the full course equivalent to one decimal" do
      expect(@course.fce).to eq 0.5
    end
  end
end
