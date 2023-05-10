require 'rails_helper'

RSpec.describe Message, type: :model do
  
  describe Message do
    before(:each) do
      User.delete_all
      Course.delete_all
      @isadminuser = User.new(username: "isadminuser", email: "isadminuser@test.com", password: "password", confirmed_at: nil)
      @isstudentuser = User.new(username: "isstudentuser", email: "isteacheruser@test.com", password: "password", confirmed_at: nil)
      token = @isadminuser.confirmation_token
      token = @isstudentuser.confirmation_token
      @isadminuser.confirm
      @isstudentuser.confirm
    end  
  
  
    describe "#create" do
      it "create message within posts" do
        newPost = Post.new(user: @isstudentuser, title: "first post", description: "test...")
        postMessage = Message.new(post: newPost, user: @isstudentuser, content: "")
        expect(@isstudentuser.has_role?(:student)).to be true
        expect(@isstudentuser.has_role?(:admin)).to be false
        expect(newPost).to be_valid
        expect(postMessage).to be_valid
      end
    end
  end
end
