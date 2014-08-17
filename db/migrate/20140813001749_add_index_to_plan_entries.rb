class AddIndexToPlanEntries < ActiveRecord::Migration
  def change
    add_index :plan_entries, [:courseplan_id, :course_id]
  end
end
