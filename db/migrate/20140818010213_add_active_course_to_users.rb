class AddActiveCourseToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :active_courseplan, references: :courseplans
  end
end
