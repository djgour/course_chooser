module Creditable
  extend ActiveSupport::Concern
  
  def calculate_credits_for(credits_int)
    (credits_int / 100.0).round(1)
  end
  
  def get_int_from_fce(credits)
    (credits * 100).to_i
  end
    
end