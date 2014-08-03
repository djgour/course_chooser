class AddDefaultCourseToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :default, references: :courseplan, index: true
  end
end
