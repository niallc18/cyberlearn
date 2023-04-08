class Admission < ApplicationRecord
  belongs_to :course
  belongs_to :user

  validates :user, :course, presence: true
  validates_presence_of :rating, if: :review?
  validates_presence_of :review, if: :rating?
  #user can't admit more than once to same course // activerecord
  validates_uniqueness_of :user_id, scope: :course_id  
  validates_uniqueness_of :course_id, scope: :user_id
  
  scope :review_needed, -> { where(rating: [0, nil, ""], review: [0, nil, ""]) }
  
  extend FriendlyId
  friendly_id :to_s, use: :slugged
  

  def to_s
    user.to_s + " " + course.to_s
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
