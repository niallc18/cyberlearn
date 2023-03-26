class Lesson < ApplicationRecord
  belongs_to :course
  validates :title, :info, :course, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged
  
  has_rich_text :info
  
  def to_s
    title
  end
  
end