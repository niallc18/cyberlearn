require 'rails_helper'

RSpec.describe Course, type: :model do

  describe Course do
    before(:each) do
      User.delete_all
      Course.delete_all
      @adminuser = User.new(username: "adminxuser", email: "adminxuser@test.com", password: "password", confirmed_at: nil)
      @teacheruser = User.new(username: "teacherxuser", email: "teacherxuser@test.com", password: "password", confirmed_at: nil)
      @studentuser = User.new(username: "studentxuser", email: "studentxuser@test.com", password: "password", confirmed_at: nil)
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
      it "teacher can create a course, update, and destroy it" do
        courseT = Course.new(user: @teacheruser, title: "courseT", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        courseTP = CoursePolicy.new(@teacheruser, courseT)
        expect(courseT).to be_valid
        expect(courseTP.create?).to be true
        expect(courseTP.update?).to be true
        expect(courseTP.destroy?).to be true
      end
      it "teacher can't update or delete a course they haven't created" do
        courseT = Course.new(user: @adminuser, title: "courseT", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        courseTP = CoursePolicy.new(@teacheruser, courseT)
        expect(courseTP.update?).to be false
        expect(courseTP.destroy?).to be false
      end
      it "student can't create a course due to policy, admin and teacher can" do
        courseS = CoursePolicy.new(@studentuser, Course)
        courseTP = CoursePolicy.new(@teacheruser, Course)
        courseAP = CoursePolicy.new(@adminuser, Course)
        expect(courseS.create?).to be false
        expect(courseTP.create?).to be true
        expect(courseAP.create?).to be true
      end
      it "student can view course only if course is approved by an admin" do
        courseA = Course.create!(user: @adminuser, title: "courseT", description: "test...", details: "Free", stage: "Newbie", logo: nil, approval: false)
        courseS = CoursePolicy.new(@studentuser, courseA)
        courseAdmin = CoursePolicy.new(@adminuser, courseA)
        expect(courseS.show?).to be false
        expect(courseAdmin.approve?).to be true
        courseA.approval = true
        expect(courseS.show?).to be true
      end
      it "rating average" do
        courseRating = Course.create!(user: @teacheruser, title: "courseRating", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        new_admission = Admission.create!(user: @adminuser, course: courseRating)
        new_admission.update(rating: 3, review: "nice")
        another_admission = Admission.create!(user: @studentuser, course: courseRating)
        another_admission.update(rating: 4, review: "nice")
        expect(courseRating).to be_valid
        expect(new_admission).to be_valid
        expect(another_admission).to be_valid
        expect(courseRating.rating_avg == 3.5).to be true
      end
    end
  
    describe "#validations" do
      it "title must be unique" do
        course1 = Course.create!(user: @adminuser, title: "TestTitle", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        course2 = Course.new(user: @teacheruser, title: "TestTitle", description: "test", details: "Free", stage: "Newbie", logo: nil)
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