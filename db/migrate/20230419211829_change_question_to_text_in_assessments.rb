class ChangeQuestionToTextInAssessments < ActiveRecord::Migration[6.1]
  change_column :assessments, :question, :text
end
