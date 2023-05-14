require 'rails_helper'

RSpec.describe Lesson, type: :model do
  
  describe Lesson do
    before(:each) do
      User.delete_all
      Course.delete_all
      @isadminuser = User.new(username: "isadminuser", email: "isadminuser@test.com", password: "password", confirmed_at: nil)
      @isteacheruser = User.new(username: "isteacheruser", email: "isteacheruser@test.com", password: "password", confirmed_at: nil)
      @isstudentuser = User.new(username: "isstudentuser", email: "isastudentuser@test.com", password: "password", confirmed_at: nil)
      token = @isadminuser.confirmation_token
      token = @isteacheruser.confirmation_token
      token = @isstudentuser.confirmation_token
      @isadminuser.confirm
      @isteacheruser.confirm
      @isstudentuser.confirm
      @isteacheruser.add_role(:teacher, nil)
    end  
  
  
    describe "#create-update-delete" do
      
      it "create course + lesson + progression" do
        courseLesson = Course.create!(user: @isteacheruser, title: "Introduction to...", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        newLesson = Lesson.create!(course: courseLesson, title: "hello", info: "...")
        newLesson2 = Lesson.create!(course: courseLesson, title: "hellooo", info: "....")
        @isstudentuser.lesson_seen(newLesson)
        expect(@isteacheruser.has_role?(:teacher)).to be true
        expect(@isteacheruser.has_role?(:admin)).to be false
        expect(courseLesson).to be_valid
        expect(newLesson).to be_valid
        expect((courseLesson.progression(@isstudentuser)).to_i == 50).to be true
      end
      it "Update lesson" do
        courseUpdate = Course.create!(user: @isteacheruser, title: "Course e.g.", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        lessonUpdate = Lesson.create!(course: courseUpdate, title: "...", info: "...")
        lessonUpdate.update(title: "I will update this course", info: "<b>I will update this course</b>")
        #lessonUpdate.update(info: "<b>I will update this course</b>")
        expect(lessonUpdate.title == "I will update this course" && lessonUpdate.info.to_plain_text == "I will update this course").to be true
        #expect(lessonUpdate.info.to_plain_text == "I will update this course").to be true
      end
      it "Delete lesson" do
        courseDelete = Course.create!(user: @isteacheruser, title: ".....", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        lessonDelete = Lesson.create!(course: courseDelete, title: "remove", info: "...")
        expect(Lesson.count == 1).to be true
        lessonDelete.delete
        expect(Lesson.count == 0).to be true
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
