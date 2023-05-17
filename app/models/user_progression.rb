# Progression connecting a user and a lesson, validate the id for user and lesson, cant be two of the same user counted for progression of a single lesson
# Reference: https://github.com/corsego
class UserProgression < ApplicationRecord
  
  belongs_to :user
  belongs_to :lesson

  
  validates :user, :lesson, presence: true

  validates_uniqueness_of :user_id, scope: :lesson_id
  validates_uniqueness_of :lesson_id, scope: :user_id
  
end