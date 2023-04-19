class Course < ApplicationRecord
  #course title can't be null and must be unique
  validates :title, uniqueness: true, presence: true, length: {:maximum => 50}
  validates :details, presence: true 
  validates :description, presence: true, length: {:minimum => 5, :maximum => 300}
  
  belongs_to :user
  has_many :admission, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :assessments, dependent: :destroy
  has_many :user_progressions, through: :lessons
  
  has_one_attached :logo
  validates :logo, attached: true, 
    content_type: ['image/png', 'image/jpg', 'image/jpeg'], 
    size: { less_than: 750.kilobytes , message: 'Logo size must be under 750 kilobytes' }  

  scope :trending_courses, -> { limit(3).order(rating_avg: :desc, created_at: :desc) }
  scope :new_courses, -> { limit(3).order(created_at: :desc) }
  scope :approval, -> { where(approval: true) }
  scope :not_approved, -> { where(approval: false) }
  
  def to_s
    title
  end
  has_rich_text :description
  
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  DETAILS = [:"Free"]
  def self.details
    DETAILS.map { |details| [details, details] }
  end

  STAGE = [:"Newbie", :"Amateur", :"Expert"]
  def self.stage
    STAGE.map { |stage| [stage, stage] }
  end
  
  def admitted(user)
    self.admission.where(user_id: [user.id], course_id: [self.id]).any?
  end
  
  def update_avg
    if admission.any? && admission.where.not(rating: nil).any?
      update_column :rating_avg, (admission.average(:rating).round(2).to_f)
    else
      update_column :rating_avg, (0)
    end
  end
  
  def progression(user)
    unless self.lessons.count == 0
      user_progressions.where(user: user).count/self.lessons.count.to_f*100
    end
  end

end 
