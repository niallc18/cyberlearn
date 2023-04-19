class Assessment < ApplicationRecord
  belongs_to :course
  
  
  
  has_rich_text :answer
  
  def to_s
    title
  end
  
  
end
