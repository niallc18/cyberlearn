require 'rails_helper'

RSpec.describe Lesson, type: :model do
  
  describe Lesson do
    before(:each) do
      User.delete_all
      Course.delete_all
      @isadminuser = User.new(username: "isadminuser", email: "isadminuser@test.com", password: "password", confirmed_at: nil)
      @isteacheruser = User.new(username: "isteacheruser", email: "isteacheruser@test.com", password: "password", confirmed_at: nil)
      token = @isadminuser.confirmation_token
      token = @isteacheruser.confirmation_token
      @isadminuser.confirm
      @isteacheruser.confirm
      @isteacheruser.add_role(:teacher, nil)
    end  
  
  
    describe "#create" do
      
      it "create course + lesson" do
        courseLesson = Course.new(user: @isteacheruser, title: "Introduction to...", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        newLesson = Lesson.new(course: courseLesson, title: "hello", info: "...")
        expect(@isteacheruser.has_role?(:teacher)).to be true
        expect(@isteacheruser.has_role?(:admin)).to be false
        expect(courseLesson).to be_valid
        expect(newLesson).to be_valid
      end
    end 
    
    describe "#validation" do
      it "validate title" do
        courseLesson = Course.new(user: @isteacheruser, title: "Introduction to...", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        lesson_title_blank = Lesson.new(course: courseLesson, title: "", info: "...")
        expect(lesson_title_blank).to be_invalid
        expect(lesson_title_blank.errors[:title]).to include("can't be blank")
      end
      it "title must be less than 50 chars" do
        courseLesson = Course.new(user: @isteacheruser, title: "Introduction to...", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        lesson_title_limit = Lesson.new(course: courseLesson, title: "", info: "...")
        over_fifty_char = "gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg"
        lesson_title_limit.title = over_fifty_char
        expect(lesson_title_limit).to be_invalid
      end
    end
  end
end
