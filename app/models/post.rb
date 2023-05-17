# model for forum
class Post < ApplicationRecord
  # associated with a user and can have many messages, if a post is deleted, all messages associated with post are deleted
  belongs_to :user
  has_many :messages, dependent: :destroy
  validates :title, presence: true, length: {:maximum => 50}
  
  extend FriendlyId
  friendly_id :to_s, use: :slugged
  
  
  has_rich_text :description
  
  def to_s
    title
  end

end
