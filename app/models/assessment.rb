# assessment model using rich text for answers and questions
class Assessment < ApplicationRecord
  belongs_to :course
  
  validates :title, presence: true, length: {:maximum => 50}
  
  has_rich_text :answers
  has_rich_text :questions
  # assessment title is used for the URL instead of ID
  extend FriendlyId
  friendly_id :to_s, use: :slugged
  
  def to_s
    title
  end

end
