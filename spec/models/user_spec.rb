require 'rails_helper'

RSpec.describe User, type: :model do
  
  describe User do
    before(:each) do
      User.delete_all
      @user = User.new(username: "newuser2", email: "newuser2@test.com", password: "password", confirmed_at: nil)
      @nextuser = User.new(username: "new1user", email: "new_user@test.com", password: "password", confirmed_at: nil)
      @user.confirm
      @nextuser.confirm
    end  

  
    describe "#confirm" do
      it "user confirmation" do
        expect(@user.confirmed?).to be true
        @user.update_column(:confirmation_token, nil)
        expect(@user.confirmation_token).to be_nil
      end  
      it "user remove account" do
        @user.delete
        expect(User.count == 1).to be true
      end  
    end

    describe "#roles" do
      it "first user should have admin role" do
        expect(@user.has_role?(:admin)).to be true
      end
      it "after first user all other users should have by default student role" do
        expect(@nextuser.has_role?(:student)).to be true
        expect(@nextuser.has_role?(:teacher)).to be false
        expect(@nextuser.has_role?(:admin)).to be false
      end
      it "user assigned with teacher role, not an admin" do
        @nextuser.add_role(:teacher, nil)
        expect(@nextuser.has_role?(:teacher)).to be true
        expect(@nextuser.has_role?(:admin)).to be false
      end
    end
  end
end

