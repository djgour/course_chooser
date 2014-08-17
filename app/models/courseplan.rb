class Courseplan < ActiveRecord::Base
  belongs_to :user
  has_many :plan_entries
  has_many :courses, through: :plan_entries
  validates :user, presence: true
  validates :name, presence: true
  validates :name, :uniqueness => {:scope => [:user_id] }
  
  def add_course!(course)
    self.plan_entries.create(course_id: course.id)
  end
  
  def remove_course!(course)
    self.plan_entries.find_by(course_id: course.id).destroy
  end
  
  def has_course?(course)
    self.plan_entries.find_by(course_id: course.id)
  end
  
end
