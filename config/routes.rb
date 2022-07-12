Rails.application.routes.draw do
  root 'init_pages#first'
#  get 'init_pages/first'
#  get 'init_pages/policy'
  get 'policy', to: 'init_pages#policy' 
end
