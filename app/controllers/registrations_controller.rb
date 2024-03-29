# generated for recaptcha and devise
# https://github.com/heartcombo/devise/wiki/How-To:-Use-Recaptcha-with-Devise
class RegistrationsController < Devise::RegistrationsController

  prepend_before_action :check_captcha, only: [:create] 

  private
    def check_captcha
      unless verify_recaptcha
        self.resource = resource_class.new sign_up_params
        resource.validate 
        set_minimum_password_length
        respond_with_navigational(resource) { render :new }
      end 
    end
end