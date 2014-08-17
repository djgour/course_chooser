require 'rails_helper'

RSpec.describe Courseplan, :type => :model do
  before do
    @user = User.create(name: "Example User", email: "user@example.com",
                        password: "foobar", password_confirmation: "foobar") 
    @courseplan = Courseplan.new()
  end

  subject { @courseplan }
  it { should respond_to(:plan_entries) }
  it { should respond_to(:add_course!) }
  it { should respond_to(:remove_course!) }
  it { should respond_to(:has_course?) }

  describe "two plans with the same name and user" do
    before do
      @duplicateplan = Courseplan.create(name: "Default", user_id: @user.id)
      @courseplan.name = "Default"
      @courseplan.user_id = @user.id
      @courseplan.save
    end

    it { should_not be_valid }
  end

  describe "two plans with the same name but different users" do
    before do
      user = User.create(name: "Dave", email: "dave@example.com",
                        password: "foobar", password_confirmation: "foobar") 
      Courseplan.create(name: "Default", user_id: user.id )
      @courseplan.name = "Default"
      @courseplan.user_id = @user.id
      @courseplan.save
    end

    it { should be_valid }
  end

  describe "created without a user" do
    before do
      @courseplan.name = "Default"
      @courseplan.save
    end

    it { should_not be_valid }
  end

  describe "created without a name" do
    before do
      @courseplan.user_id = @user.id
      @courseplan.name = ""
      @courseplan.save
    end

    it { should_not be_valid }
  end

  describe "created with a user_id of a non-existent user" do
    before do
      @courseplan.user_id = 833
      @courseplan.name = "Default"
      @courseplan.save
    end

    it { should_not be_valid }
  end


  describe "deleting the parent user" do
    before do
      @courseplan.user_id = @user.id
      @courseplan.name = "Default"
      @courseplan.save
    end

    it "should delete associated courseplans" do
      expect { @user.destroy }.to change(Courseplan, :count).by(-1)
    end
  end
  
  describe "adding a course" do
    let(:course) { FactoryGirl.create(:course) }
    before do
      @courseplan.name = "Default"
      @courseplan.user_id = @user.id
      @courseplan.save
      @courseplan.add_course!(course)
    end
    
    it "should include the course in the courseplan" do
       expect(@courseplan.courses).to include(course)
    end
    
    it "should tell you the course is in it" do
      expect(@courseplan.has_course?(course)).to be_truthy
    end
    
    it "should allow you to remove it" do
      @courseplan.remove_course!(course)
      expect(@courseplan.courses).to_not include(course) 
    end
    
    it "should tell you if a course is removed" do
      @courseplan.remove_course!(course)
      expect(@courseplan.has_course?(course)).to be_falsey
    end
  end
  
end