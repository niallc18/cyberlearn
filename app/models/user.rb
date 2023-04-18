class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable
  rolify       
  attr_accessor :login
  has_many :courses
  has_many :admission
  has_many :user_progressions
  has_many :posts
  has_many :messages
  
  def to_s
  email  
  end

  extend FriendlyId
  friendly_id :email, use: :slugged

  after_create :assign_default_role

  def assign_default_role
    if User.count == 1
      self.add_role(:admin) if self.roles.blank? #admin for initial user
      self.add_role(:teacher) 
      self.add_role(:student)
    else
      self.add_role(:student) if self.roles.blank?
    end
  end
  
  validate :must_have_a_role, on: :update
  
  def online?
    updated_at > 5.minutes.ago
  end

  def admit_course(course)
    self.admission.create(course: course, price: course.details)
  end
  
  def lesson_seen(lesson)
    unless self.user_progressions.where(lesson: lesson).any?
      self.user_progressions.create(lesson: lesson)
    end
  end
  
  #https://web-crunch.com/posts/devise-login-with-username-email fix for login bug with user/email
  def self.find_for_database_authentication warden_condition
    conditions = warden_condition.dup
    login = conditions.delete(:login)
    where(conditions).where(
      ["lower(username) = :value OR lower(email) = :value",
      { value: login.strip.downcase}]).first
  end

  private
  def must_have_a_role
    unless roles.any?
      errors.add(:roles, "must have at least one role")
    end
  end

  
end
