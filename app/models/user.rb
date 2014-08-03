class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  attr_accessor :default_id

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence:     true,
                    format:       { with: VALID_EMAIL_REGEX },
                    uniqueness:   { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

  has_many :courseplans, dependent: :destroy

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  def default_courseplan
    ######################
    # Refactor this.... #
    #####################
    
    return nil unless self.courseplans.any?
    
    if self.courseplans.any? && Courseplan.find_by(id: self.default_id, user_id: self.id).nil?
      self.default_id = self.courseplans.first.id
    end
    
    Courseplan.find_by(id: self.default_id, user_id: self.id)
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
  
  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
    
end
