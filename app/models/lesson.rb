class Lesson < ApplicationRecord
  belongs_to :course
  has_many :user_progressions, dependent: :destroy
  validates :info, :course, presence: true
  validates :title, presence: true, length: {:maximum => 50}
  
  include RankedModel
  ranks :row_order, :with_same => :course_id, default_position: 1
  
  after_create :set_position

  extend FriendlyId
  friendly_id :title, use: :slugged
  
  has_rich_text :info

  def set_position
    row_order_rank + 1 
  end
  
  def to_s
    title
  end
  
  def seen(user)
    self.user_progressions.where(user: user).present?
    #self.user_progressions.where(user_id: [user.id], lesson_id: [self.id]).present?
  end
  
end