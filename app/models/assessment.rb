class Assessment < ApplicationRecord
  belongs_to :course
  
  validates :title, presence: true, length: {:maximum => 50}
  
  has_rich_text :answers
  has_rich_text :questions
  
  extend FriendlyId
  friendly_id :to_s, use: :slugged
  
  def to_s
    title
  end

end
