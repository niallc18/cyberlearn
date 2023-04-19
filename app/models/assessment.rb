class Assessment < ApplicationRecord
  belongs_to :course
  
  has_rich_text :answers
  has_rich_text :questions
  
  def to_s
    title
  end

end
