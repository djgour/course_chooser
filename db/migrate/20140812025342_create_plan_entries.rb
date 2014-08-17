class CreatePlanEntries < ActiveRecord::Migration
  def change
    create_table :plan_entries do |t|
      t.references :courseplan, index: true
      t.references :course, index: true
      t.datetime :semester

      t.timestamps
    end
  end
end
