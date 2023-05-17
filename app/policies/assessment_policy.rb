# policies defined for assessments
# Reference: https://github.com/varvet/pundit
# Reference: https://github.com/RolifyCommunity/rolify
class AssessmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    @user.has_role?(:admin) || @record.course.admitted(@user) == true || @record.course.user_id == @user.id
  end

  def edit?
    @user.present? && @record.course.user_id == @user.id 
  end

  def update?
    @record.course.user_id == @user.id
  end

  def new?
  end

  def create?
    @record.course.user_id == @user.id || @user.has_role?(:admin) 
  end

  def destroy?
    @record.course.user_id == @user.id
  end
end