class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    @record.approval || @user.has_role?(:admin) || @user.present? && @record.user_id == @user.id 
  end

  def edit?
    @user.has_role?(:admin) || @record.user_id == @user.id
  end
  
  def update?
    @user.has_role?(:admin) || @record.user_id == @user.id
  end

  def new?
    @user.has_role?(:teacher)
  end

  def create?
    @user.has_role?(:teacher)
  end
  
  def creator?
    @record.user == @user || @user.has_role?(:admin)
  end
  
  def approve?
    @user.has_role?(:admin)
  end

  def destroy?
    @user.has_role?(:admin) || @record.user_id == @user.id
  end

end
