require 'rails_helper'

RSpec.describe Admission, type: :model do

  describe Admission do
    before(:each) do
      User.delete_all
      Course.delete_all
      Admission.delete_all
      @user = User.new(username: "adminfirst", email: "adminfirst@test.com", password: "password", confirmed_at: nil)
      @anotheruser = User.new(username: "studentvalidate", email: "studentvalidate@test.com", password: "password", confirmed_at: nil)
      @admissionuser = User.new(username: "admissionuser", email: "admissionuser@test.com", password: "password", confirmed_at: nil)
      token = @user.confirmation_token
      token = @anotheruser.confirmation_token
      token = @admissionuser.confirmation_token
      @user.confirm
      @anotheruser.confirm
      @admissionuser.confirm

    end  

    describe "#setup" do
      it "user setup" do
        expect(@admissionuser.has_role?(:student)).to be true
        expect(@admissionuser.has_role?(:admin)).to be false
        expect(@user.has_role?(:admin)).to be true
        expect(@anotheruser.has_role?(:student)).to be true
        expect(@anotheruser.has_role?(:admin)).to be false
      end
      it "course setup" do
        courseAdmission = Course.new(user: @user, title: "courseAdmission", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        new_admission = Admission.new(user: @admissionuser, course: courseAdmission)
        expect(courseAdmission).to be_valid
        expect(new_admission).to be_valid
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
    end
  
      
  end  
end
