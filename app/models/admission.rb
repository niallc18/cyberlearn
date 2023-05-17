# Reference: https://github.com/corsego/corsego
class Admission < ApplicationRecord
  belongs_to :course
  belongs_to :user

  validates :user, :course, presence: true
  # if there is a rating there must be a review, vice versa
  validates_presence_of :rating, if: :review?
  validates_presence_of :review, if: :rating?
  #user can't admit more than once to same course // activerecord
  validates_uniqueness_of :user_id, scope: :course_id  
  validates_uniqueness_of :course_id, scope: :user_id
  # scope for reviews, sorting by no review or rating found, or the opposite, used for view
  scope :review_needed, -> { where(rating: [0, nil, ""], review: [0, nil, ""]) }
  scope :has_review, -> { where.not(rating: [0, nil, ""]) }
  # username is used for URL instead of ID
  extend FriendlyId
  friendly_id :to_s, use: :slugged
  

  def to_s
    (user.username).to_s 
  end
  
  after_save do
    unless rating.nil?
      course.update_avg
    end
  end

  after_destroy do
    course.update_avg
  end

end
