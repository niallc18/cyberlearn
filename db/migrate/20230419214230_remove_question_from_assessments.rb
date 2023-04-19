class RemoveQuestionFromAssessments < ActiveRecord::Migration[6.1]
  def change
    remove_column :assessments, :question
  end
end
