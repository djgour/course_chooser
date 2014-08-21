class PlanEntry < ActiveRecord::Base
  include Semesterable
  belongs_to :courseplan
  belongs_to :course
  
  validates_uniqueness_of :course_id, scope: :courseplan_id
  
  # SEASONS is defined in initalizers because it's shared across models
  # (at least as of the writing of this comment.)
  
  def set_semester(options = {})
    year = options[:year]
    season = options[:season]
    if (!year.is_a? Integer) || (!GlobalConstants::SEASONS.has_key? season)
      self.update(semester: nil)
    else
      self.update(semester: DateTime.new(year, GlobalConstants::SEASONS[season].first))
    end
  end
  
  def no_semester!
    self.update(semester: nil)
  end
  
  def semester_to_string
      convert_semester_datetime_to_string(self.semester)
  end
  
end
