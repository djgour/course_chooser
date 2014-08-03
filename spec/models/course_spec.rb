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
end
