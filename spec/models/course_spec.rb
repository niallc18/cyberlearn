require 'rails_helper'

RSpec.describe Course, type: :model do

  describe Course do
    before(:each) do
      User.delete_all
      Course.delete_all
      @adminuser = User.new(username: "adminxuser", email: "adminxuser@test.com", password: "password", confirmed_at: nil)
      token = @adminuser.confirmation_token
      @teacheruser = User.new(username: "teacherxuser", email: "teacherxuser@test.com", password: "password", confirmed_at: nil)
      token = @teacheruser.confirmation_token
      @studentuser = User.new(username: "studentxuser", email: "studentxuser@test.com", password: "password", confirmed_at: nil)
      token = @studentuser.confirmation_token
      @adminuser.confirm
      @teacheruser.confirm
      @studentuser.confirm
      @teacheruser.add_role(:teacher, nil)
    end
    
    describe "#roles" do
      it "user has teacher role" do
        expect(@teacheruser.has_role?(:teacher)).to be true
        expect(@teacheruser.has_role?(:admin)).to be false
      end
      it "user has student role" do
        expect(@studentuser.has_role?(:student)).to be true
        expect(@studentuser.has_role?(:teacher)).to be false
        expect(@studentuser.has_role?(:admin)).to be false
      end
    end
    describe "#create" do
      it "teacher can create a course" do
        courseT = Course.new(user: @teacheruser, title: "courseT", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        #courseT.skip_validation = true
        expect(courseT).to be_valid
      end
      it "student can't create a course due to policy, admin and teacher can" do
        courseS = CoursePolicy.new(@studentuser, Course)
        courseTP = CoursePolicy.new(@teacheruser, Course)
        courseAP = CoursePolicy.new(@adminuser, Course)
        expect(courseS.create?).to be false
        expect(courseTP.create?).to be true
        expect(courseAP.create?).to be true
      end
    end
  
    describe "#validations" do
      it "title must be unique" do
        course1 = Course.create!(user: @adminuser, title: "TestTitle", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        #course1.skip_validation = true
        course2 = Course.new(user: @teacheruser, title: "TestTitle", description: "test", details: "Free", stage: "Newbie", logo: nil)
        #course2.skip_validation = true
        expect(course2).to be_invalid
        expect(course2.errors[:title]).to include("has already been taken")
      end
      it "title must be present" do
        course_title_blank = Course.new(user: @teacheruser, title: "", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        expect(course_title_blank).to be_invalid
        expect(course_title_blank.errors[:title]).to include("can't be blank")
      end
      it "title must be 50 chars or less" do
        course_title_limit = Course.new(user: @teacheruser, title: "", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        over_fifty_char = "gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg"
        course_title_limit.title = over_fifty_char
        expect(course_title_limit).to be_invalid
      end
    end 
  end
end