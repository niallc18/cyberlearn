class AddTitleToAssessments < ActiveRecord::Migration[6.1]
  def change
    add_column :assessments, :title, :string
  end
end
