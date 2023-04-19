class AddQuestionsAndAnswersToAssessments < ActiveRecord::Migration[6.1]
  def change
    add_column :assessments, :questions, :text
    add_column :assessments, :answers, :text
  end
end
