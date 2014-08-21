class Courseplan < ActiveRecord::Base
  include Semesterable
  belongs_to :user
  has_many :plan_entries, dependent: :destroy
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
  
  def courses_by_semester
    semesters = ActiveSupport::OrderedHash.new{ |hash, key| hash[key] = Array.new }
    self.plan_entries.order('semester ASC').each do |entry|
      sem = entry.semester
      if sem.nil?
        semesters[:no_semester] << entry
      else
        season = get_season_from(sem)
        year = get_year_from(sem)
        semester_key = "#{season}_#{year}".to_sym
        semesters[semester_key] << entry
      end
    end
    semesters
  end
  
end
