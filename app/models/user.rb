class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence:     true,
                    format:       { with: VALID_EMAIL_REGEX },
                    uniqueness:   { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }, if: :validate_password?
  #validate :check_password, on: :update
  has_many :courseplans, dependent: :destroy
  belongs_to :active_course_plan,
             class_name: "Courseplan",
             foreign_key: "active_courseplan_id"


  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  def active_courseplan
    if !self.courseplans.any?
      self.update(active_courseplan_id: nil)
      return nil 
    elsif self.active_courseplan_id.nil? || self.courseplans.find_by(id: self.active_courseplan_id).nil?
      active_courseplan = self.courseplans.first
      self.update(active_courseplan_id: active_courseplan.id)
    end

    active_courseplan ||= self.courseplans.find_by(id: self.active_courseplan_id)

  end

  def make_active_plan(plan)
    self.update(active_courseplan_id: plan.id)
  end

  def all_courseplans(options={})
    if options[:except]
      self.courseplans.where.not(id: options[:except].id)
    else
      self.courseplans.all
     end
  end
  
  def has_multiple_courseplans
    courseplans.size > 1
  end

  def is_admin?
    self.admin
  end
  
  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

    def validate_password?
      password.present? || password_confirmation.present?
    end

    def check_password
    return unless validate_password?
      validates :password, length: { minimum: 6 }
    end
end
