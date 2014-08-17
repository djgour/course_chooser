class PlanEntry < ActiveRecord::Base
  belongs_to :courseplan
  belongs_to :course
  
  validates_uniqueness_of :course_id, scope: :courseplan_id
end
