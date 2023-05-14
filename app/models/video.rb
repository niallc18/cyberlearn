#Reference:
#https://stackoverflow.com/questions/61867995/how-to-embed-an-iframe-with-actiontext-trix-on-ruby-on-rails
#https://www.youtube.com/watch?v=2iGBuLQ3S0c&ab_channel=Confreaks

class Video
  include ActiveModel::Model
  include ActiveModel::Attributes
  include GlobalID::Identification
  include ActionText::Attachable

  attribute :id

  def self.find(id)
    new(id: id)
  end

  def thumbnail_url
    "http://i3.ytimg.com/vi/#{id}/maxresdefault.jpg"
  end

  def to_trix_content_attachment_partial_path
    "videos/thumbnail"
  end
end