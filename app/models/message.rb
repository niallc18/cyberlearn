# message model
class Message < ApplicationRecord
  # associations with post and user, belonging to both
  belongs_to :user
  belongs_to :post

  has_rich_text :content
  
end