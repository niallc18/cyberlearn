class PostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    @user.present?
  end

  def edit?
    @user.has_role?(:admin) || @record.user_id == @user.id
  end
  
  def update?
    @user.has_role?(:admin) || @record.user_id == @user.id
  end

  def new?
    @user.has_role?(:student) || @user.has_role?(:teacher) || @user.has_role?(:admin)
  end

  def create?
    @user.has_role?(:student) || @user.has_role?(:teacher) || @user.has_role?(:admin)
  end

  def destroy?
    @user.has_role?(:admin) || @record.user_id == @user.id
  end

end
