require 'rails_helper'

RSpec.describe Admission, type: :model do

  describe Admission do
    before(:each) do
      User.delete_all
      Course.delete_all
      Lesson.delete_all 
      Assessment.delete_all
      Admission.delete_all
      @user = User.new(username: "adminfirst", email: "adminfirst@test.com", password: "password", confirmed_at: nil)
      @anotheruser = User.new(username: "studentvalidate", email: "studentvalidate@test.com", password: "password", confirmed_at: nil)
      @admissionuser = User.new(username: "admissionuser", email: "admissionuser@test.com", password: "password", confirmed_at: nil)
      @user.confirm
      @anotheruser.confirm
      @admissionuser.confirm

    end  

    describe "#permissions" do
      it "user setup roles" do
        expect(@user.has_role?(:admin)).to be true
        expect(@anotheruser.has_role?(:student)).to be true
        expect(@anotheruser.has_role?(:admin)).to be false
        expect(@admissionuser.has_role?(:student)).to be true
        expect(@admissionuser.has_role?(:admin)).to be false
      end
      it "course + admission" do
        courseAdmission = Course.new(user: @user, title: "courseAdmission", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        new_admission = Admission.new(user: @admissionuser, course: courseAdmission)
        expect(courseAdmission).to be_valid
        expect(new_admission).to be_valid
        new_admission.update(rating: 3, review: "nice")
        expect(new_admission).to be_valid
      end
        it "student can only view lessons and assessments if they're admitted, but can view the course" do
        courseA = Course.create!(user: @user, title: "courseT", description: "test...", details: "Free", stage: "Newbie", logo: nil, approval: true)
        newLesson = Lesson.create!(course: courseA, title: "hello", info: "...")
        newAssessment = Assessment.create!(course: courseA, title: "test", questions: "hello", answers: "...")
        new_admission = Admission.create!(user: @admissionuser, course: courseA)
        courseView = CoursePolicy.new(@anotheruser, courseA)
        courseS = LessonPolicy.new(@admissionuser, newLesson)
        courseAS = AssessmentPolicy.new(@admissionuser, newAssessment)
        courseNot = LessonPolicy.new(@anotheruser, newLesson)
        courseANot = AssessmentPolicy.new(@anotheruser, newAssessment)
        expect(courseView.show?).to be true
        expect(courseS.show?).to be true
        expect(courseAS.show?).to be true
        expect(courseNot.show?).to be false
        expect(courseANot.show?).to be false
      end
    end
    
    describe "#validation" do
      it "validate user can only admit once to same course" do  
        courseAdmission = Course.create!(user: @user, title: "courseAdmission", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        new_admission = Admission.create!(user: @anotheruser, course: courseAdmission)
        same_course_admission = Admission.new(user: @anotheruser, course: courseAdmission)
        expect(courseAdmission).to be_valid
        expect(new_admission).to be_valid
        expect(same_course_admission).to be_invalid
      end
      it "rating must have review" do
        courseRating = Course.create!(user: @user, title: "courseRating", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        new_admission = Admission.create!(user: @admissionuser, course: courseRating)
        new_admission.update(rating: 3, review: nil)
        expect(new_admission).to be_invalid
      end
      it "review must have rating" do
        courseReview = Course.create!(user: @user, title: "courseReview", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        new_admission = Admission.create!(user: @admissionuser, course: courseReview)
        new_admission.update(rating: nil, review: "nice")
        expect(new_admission).to be_invalid
      end
    end
  end  
end
