class Post < ApplicationRecord
  belongs_to :user
  
  extend FriendlyId
  friendly_id :to_s, use: :slugged
  
  has_rich_text :description
  
  def to_s
    title
  end
  
end
