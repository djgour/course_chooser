class CreateCourseplans < ActiveRecord::Migration
  def change
    create_table :courseplans do |t|
      t.string :name
      t.references :user, index: true

      t.timestamps
    end
  end
end
