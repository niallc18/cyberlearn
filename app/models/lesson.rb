class Lesson < ApplicationRecord
  belongs_to :course
  has_many :user_progressions
  validates :title, :info, :course, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged
  
  has_rich_text :info
  
  def to_s
    title
  end
  
  def seen(user)
    self.user_progressions.where(user: user).present?
    #self.user_progressions.where(user_id: [user.id], lesson_id: [self.id]).present?
  end
  
end