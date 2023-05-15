Recaptcha.configure do |config|
  if Rails.env.production?
    config.site_key  = ENV['RECAPTCHA_SITE_KEY'] 
    config.secret_key = ENV['RECAPTCHA_SITE_KEY']
  else
    config.site_key  = Rails.application.credentials.dig(:recaptcha, :site_key) 
    config.secret_key = Rails.application.credentials.dig(:recaptcha, :secret_key)
  end
end

