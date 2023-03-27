class CreateAdmissions < ActiveRecord::Migration[6.1]
  def change
    create_table :admissions do |t|
      t.references :course, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rating
      t.text :review
      t.integer :price

      t.timestamps
    end
  end
end
