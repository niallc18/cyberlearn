class AddSlugToAssessments < ActiveRecord::Migration[6.1]
  def change
    add_column :assessments, :slug, :string
    add_index :assessments, :slug, unique: true
  end
end
