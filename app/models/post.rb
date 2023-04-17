class Post < ApplicationRecord
  
  belongs_to :user
  has_many :messages
  
  extend FriendlyId
  friendly_id :to_s, use: :slugged
  
  has_rich_text :description
  
  def to_s
    title
  end
  
  def username
    self.email.split(/@/).first
  end
  
end
