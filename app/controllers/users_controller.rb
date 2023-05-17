# define actions for users, using pundit gem to determine which users can have access to certain actions, corresponding to views
# rolify gem user must have a role
# ransack for indexing all users
# Reference: https://github.com/corsego/corsego
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true)
    authorize @users
  end
  
  def show
  end
  
  def edit
    authorize @user
  end

  def update
    authorize @user
    if @user.update(user_params)
      redirect_to users_path, notice: 'User roles have been updated.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.friendly.find(params[:id])
  end

  def user_params
    params.require(:user).permit({role_ids: []})
  end
end