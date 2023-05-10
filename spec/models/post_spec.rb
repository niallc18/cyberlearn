require 'rails_helper'

RSpec.describe Post, type: :model do
  
  describe Post do
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
      it "create post" do
        newPost = Post.new(user: @isstudentuser, title: "first post", description: "test...")
        expect(@isstudentuser.has_role?(:student)).to be true
        expect(@isstudentuser.has_role?(:admin)).to be false
        expect(newPost).to be_valid
      end
    end
    
    describe "#validation" do
      it "validate title" do
        post_title_blank = Post.new(user: @isstudentuser, title: "", description: "test...")
        expect(post_title_blank).to be_invalid
        expect(post_title_blank.errors[:title]).to include("can't be blank")
      end
      it "title must be less than 50 chars" do
        post_title_limit = Post.new(user: @isstudentuser, title: "", description: "test...")
        over_fifty_char = "gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg"
        post_title_limit.title = over_fifty_char
        expect(post_title_limit).to be_invalid
      end
    end
  end
end
