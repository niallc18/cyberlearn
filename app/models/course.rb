class Course < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true, length: {:minimum => 5}
  
  belongs_to :user
  has_many :admission
  has_many :lessons, dependent: :destroy
  
  
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
    self.admissions.where(user_id: [user.id], course_id: [self.id].empty?)
  end

end 
