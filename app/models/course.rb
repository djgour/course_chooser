class Course < ActiveRecord::Base
  include Creditable
  
  validates :code, length: { is: 8 }
  validates :description, length: { minimum: 10 }
  validates :name, presence: true
  
  has_many :plan_entries
  has_many :courseplans, through: :plan_entries
  
  def self.all_sorted
    self.all.sort_by{ |e| e[:code] }
  end
  
  def fce
    calculate_credits_for(self.credits)
  end
  
end
