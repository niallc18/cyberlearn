require 'rails_helper'

RSpec.describe Assessment, type: :model do
  
  describe Assessment do
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
      it "create course + assessment" do
        courseAssessment = Course.new(user: @isteacheruser, title: "Introduction to...", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        newAssessment = Assessment.new(course: courseAssessment, title: "hello", questions: "", answers: "")
        expect(@isteacheruser.has_role?(:teacher)).to be true
        expect(@isteacheruser.has_role?(:admin)).to be false
        expect(courseAssessment).to be_valid
        expect(newAssessment).to be_valid
      end
    end
    
    describe "#validation" do
      it "validate title" do
        courseAssessment = Course.new(user: @isteacheruser, title: "Introduction to...", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        assessment_title_blank = Assessment.new(course: courseAssessment, title: "", questions: "", answers: "")
        expect(assessment_title_blank).to be_invalid
        expect(assessment_title_blank.errors[:title]).to include("can't be blank")
      end
      it "title must be less than 50 chars" do
        courseAssessment = Course.new(user: @isteacheruser, title: "Introduction to...", description: "test...", details: "Free", stage: "Newbie", logo: nil)
        assessment_title_limit = Assessment.new(course: courseAssessment, title: "", questions: "", answers: "")
        over_fifty_char = "gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg"
        assessment_title_limit.title = over_fifty_char
        expect(assessment_title_limit).to be_invalid
      end
    end
  end
end
