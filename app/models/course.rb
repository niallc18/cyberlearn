# Reference: https://github.com/corsego/corsego
class Course < ApplicationRecord
  #course title can't be null and must be unique
  validates :title, uniqueness: true, presence: true, length: {:maximum => 50}
  validates :details, presence: true 
  validates :description, presence: true, length: {:minimum => 5, :maximum => 750}
  
  belongs_to :user
  has_many :admissions, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :assessments, dependent: :destroy
  has_many :user_progressions, through: :lessons
  # all associations with the course are destroyed when a user deletes that course 
  has_one_attached :logo
  validates :logo,
    content_type: ["image/png", "image/jpg", "image/jpeg"], 
    size: { less_than: 750.kilobytes , message: "Logo size must be < 750 kilobytes" }  
    # logo must be under 750kb and be of type png, jpg, jpeg
    # scopes for defining categories and for the navbar dropdowns, used in views,
  scope :trending_courses, -> { limit(3).order(rating_avg: :desc, created_at: :desc) }
  scope :new_courses, -> { limit(3).order(created_at: :desc) }
  scope :advanced_courses, -> { limit(3).where(stage: :"Expert") }
  scope :beginner_courses, -> { limit(3).where(stage: :"Newbie") }
  scope :approval, -> { where(approval: true) }
  scope :not_approved, -> { where(approval: false) }
  
  def to_s
    title
  end
  
  has_rich_text :description
  # course title in URL instead of ID
  extend FriendlyId
  friendly_id :title, use: :slugged
  # details is only set as FREE option in an array
  DETAILS = [:"Free"]
  def self.details
    DETAILS.map { |details| [details, details] }
  end
  # stages for the user to select from, used in scopes for sorting courses based on difficulty
  STAGE = [:"Newbie", :"Amateur", :"Expert"]
  def self.stage
    STAGE.map { |stage| [stage, stage] }
  end
  # method for determining if a user has been registered to a course
  def admitted(user)
    self.admissions.where(user_id: [user.id], course_id: [self.id]).any?
  end
  # method for updating the attribute rating avg, rounding to 1dp
  def update_avg
    if admissions.any? && admissions.where.not(rating: nil).any?
      update_column :rating_avg, (admissions.average(:rating).round(2).to_f)
    else
      update_column :rating_avg, (0)
    end
  end
  
  # method for calculating progression based on lessons seen, converted to a percentage
  def progression(user)
    unless self.lessons.count == 0
      user_progressions.where(user: user).count/self.lessons.count.to_f*100
    end
  end

end 
