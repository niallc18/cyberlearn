class AdmissionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    @user.has_role?(:admin)
  end

  def edit?
    @record.user_id == @user.id
  end

  def update?
    @record.user_id == @user.id
  end

  def destroy?
    @user.has_role?(:admin) || @record.user_id == @user.id
  end
end