class Courseplan < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  validates :name, presence: true
  validates :name, :uniqueness => {:scope => [:user_id] }
end
