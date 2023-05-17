# message controller setting the id of a message on a specific id of a post, acting as a reply
# friendly id for easier searching, e.g. post title can be searched instead of id being used
class MessagesController < ApplicationController

  def create
    @message = Message.new(message_params)
    @post = Post.friendly.find(params[:post_id])
    @message.post_id = @post.id
    @message.user = current_user

    respond_to do |format|
      if @message.save
        format.html { redirect_to post_url(@post), notice: 'Message sent' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render 'posts/messages/new' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end

  end
  
  def destroy
    @post = Post.friendly.find(params[:post_id])
    @message = Message.find(params[:id])
    @message.destroy
    respond_to do |format|
      format.html { redirect_to post_url(@post), notice: 'Message Deleted' }
      format.json { head :no_content }
    end
  end


  private
    def message_params
      params.require(:message).permit(:content)
    end
end