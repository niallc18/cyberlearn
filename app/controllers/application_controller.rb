class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery
  
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  include Pagy::Backend

  before_action :set_global_variables, if: :user_signed_in?
  def set_global_variables
    @ransack_courses = Course.ransack(params[:courses_search], search_key: :courses_search) #navbar search
  end
  
  
  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: [:login, :password]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end  
  
  
  private

  def user_not_authorized #pundit
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end 
end
