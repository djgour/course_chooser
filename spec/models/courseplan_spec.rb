require 'rails_helper'

RSpec.describe Courseplan, :type => :model do
  before do
    @user = User.create(name: "Example User", email: "user@example.com",
                        password: "foobar", password_confirmation: "foobar") 
    @courseplan = Courseplan.new()
  end

  subject { @courseplan }

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
  
end