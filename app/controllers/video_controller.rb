class VideoController < ApplicationController
  def show
    @video = Video.new(id: params[:id])
    render json: {
      sgid: @video.attachable_sgid,
      content: render_to_string(partial: "videos/thumbnail", locals: { video: @video }, formats: [:html])
    }
  end
end