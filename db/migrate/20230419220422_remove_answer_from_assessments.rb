class RemoveAnswerFromAssessments < ActiveRecord::Migration[6.1]
  def change
    remove_column :assessments, :answer
  end
end
