# Reference: https://github.com/corsego
class Lesson < ApplicationRecord
  belongs_to :course
  # when a lesson is destroyed, the progression is updated and removed from the calculation
  has_many :user_progressions, dependent: :destroy
  validates :info, :course, presence: true
  validates :title, presence: true, length: {:maximum => 50}
  
  include RankedModel
  ranks :row_order, :with_same => :course_id, default_position: 1
  
  after_create :set_position
  # ranked model gem
  # lesson title is displayed in URL instead of ID
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  has_rich_text :info
  # rankning starts from 0, hence the +1
  def set_position
    row_order_rank + 1 
  end
  
  def to_s
    title
  end
  # method for when a user has seen a course, used in lesson view for changing icon
  def seen(user)
    self.user_progressions.where(user: user).present?
  end
  
end