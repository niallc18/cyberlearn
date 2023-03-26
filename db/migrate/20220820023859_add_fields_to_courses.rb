class AddFieldsToCourses < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :details, :text
    add_column :courses, :stage, :string
  end
end
