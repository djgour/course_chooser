require 'rails_helper'

RSpec.describe User, :type => :model do
  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar") 
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:active_courseplan) }
  it { should respond_to(:admin) }


  it { should be_valid }
  it { should_not be_admin }

  describe "with admin set to true" do
    before do
      @user.save@user.toggle!(:admin)
    end
  end


  describe "when name is blank" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is blank" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = ('a' * 51) }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = ["user@foo,com", "user_at_foo.org", "user@foo.
                    foo@bar_baz.com", "foo@bar+baz.com"]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = ["user@foo.COM", "A_UR-ER@f.b.org", "frst.lst@foo.jp", "a+b@baz.cn"]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already registered" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end

    it { should_not be_valid }

  end

  describe "email with mixed case" do
    let(:mixed_case_email) { "FooBar@ExaMPle.Com"}

    it "should be saved as all lower case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com", 
                       password: " ", password_confirmation: " ")
    end

    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }

    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_falsey }
    end
  end

  describe "with a password that's too short" do
    before do
      @user = User.create(name: "Example User", email: "user@example.org",
                       password: "pwd", password_confirmation: "pwd")
    end

    it { should_not be_valid }
  end

  describe "remember token" do
    before { @user.save }
    it { expect(@user.remember_token).not_to be_blank }
  end
  
  describe "default courseplan" do
    before do
       @user.save
       if @user.courseplans.any?
         @user.courseplans.all.each do |plan|
           plan.destroy
         end
       end
     end
    
    it "should return nil if user has no courseplans" do
      expect(@user.active_courseplan).to be_nil
    end
      
    it "should set the first plan as the default if there is none" do
      @user.courseplans.create(name: "First")
      @user.courseplans.create(name: "Second")
      expect(@user.courseplans.count).to eq 2
      expect(@user.active_courseplan.name).to eq "First"
      @user.active_courseplan.destroy
      expect(@user.active_courseplan.name).to eq "Second"
    end

    describe "multiple courseplans" do
      before do
        @plan1 = @user.courseplans.create(name: "First")
        @plan2 = @user.courseplans.create(name: "Second")
        @user.active_courseplan
      end

      it "should allow you to change default courseplans" do
        expect(@user.active_courseplan.name).to eq @plan1.name
        @user.make_active_plan(@plan2)
        expect(@user.active_courseplan.name).to eq @plan2.name
      end
    end
  end

end
