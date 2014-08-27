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
  
  def update_fce_from_params(fce_string)
    # add in some verification that string is numeric
    # in the meantime, bad data results in 0
    
    new_credits = get_int_from_fce(fce_string.to_f)
    self.update(credits: new_credits)
  end
  
end
