class AddSlugToAdmissions < ActiveRecord::Migration[6.1]
  def change
    add_column :admissions, :slug, :string
    add_index :admissions, :slug, unique: true
  end
end
