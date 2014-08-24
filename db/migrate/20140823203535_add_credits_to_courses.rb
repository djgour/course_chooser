class AddCreditsToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :credits, :integer, default: 50
  end
end
