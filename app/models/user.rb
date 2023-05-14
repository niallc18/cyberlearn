class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable, authentication_keys: [:login]
  rolify   
  
  attr_writer :login
  has_many :courses, dependent: :destroy
  has_many :admissions, dependent: :destroy
  has_many :user_progressions, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :messages, dependent: :destroy
  
  def to_s
    email  
  end

  extend FriendlyId
  friendly_id :username, use: :slugged

  after_create :default_role

  def default_role
    if User.count == 1
      self.add_role(:admin) if self.roles.blank? #admin for initial user
      self.add_role(:teacher) 
      self.add_role(:student)
    else
      self.add_role(:student) if self.roles.blank?
    end
  end
  
  def online?
    updated_at > 5.minutes.ago
  end

  def admit_course(course)
    self.admissions.create(course: course, price: course.details)
  end
  
  def lesson_seen(lesson)
    unless self.user_progressions.where(lesson: lesson).any?
      self.user_progressions.create(lesson: lesson)
    end
  end
  
  def login
    @login || self.username || self.email
  end
  
  #https://github.com/heartcombo/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  validate :need_role, on: :update

  private
  def need_role
    unless roles.any?
      errors.add(:roles, "You must have at least one role!")
    end
  end

  
end
