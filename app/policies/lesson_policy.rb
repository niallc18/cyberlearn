class LessonPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    @user.has_role?(:admin) || @record.course.admitted(@user) == true || @record.course.user_id == @user.id
  end

  def edit?
    @record.course.user_id && @user.present? == @user.id || @user.has_role?(:admin) 
  end

  def update?
    @record.course.user_id == @user.id
  end

  def new?
  end

  def create?
    @record.course.user_id == @user.id
  end

  def destroy?
    @record.course.user_id == @user.id
  end
end