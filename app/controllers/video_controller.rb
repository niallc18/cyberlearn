#Reference:
#https://stackoverflow.com/questions/61867995/how-to-embed-an-iframe-with-actiontext-trix-on-ruby-on-rails
#https://www.youtube.com/watch?v=2iGBuLQ3S0c&ab_channel=Confreaks
class VideoController < ApplicationController
  def show
    @video = Video.new(id: params[:id])
    render json: {
      sgid: @video.attachable_sgid,
      content: render_to_string(partial: "videos/thumbnail", locals: { video: @video }, formats: [:html])
    }
  end
end