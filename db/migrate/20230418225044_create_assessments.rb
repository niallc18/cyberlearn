class CreateAssessments < ActiveRecord::Migration[6.1]
  def change
    create_table :assessments do |t|
      t.string :question
      t.text :answer
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
