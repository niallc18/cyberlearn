class Admission < ApplicationRecord
  belongs_to :course
  belongs_to :user

  validates :user, :course, presence: true
  #user can't admit more than once to same course // activerecord
  validates_uniqueness_of :user_id, scope: :course_id  
  validates_uniqueness_of :course_id, scope: :user_id

end
