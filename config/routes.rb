Rails.application.routes.draw do
  devise_for :users
  resources :courses do
    resources :lessons
  end
  resources :users, only: [:index, :edit, :show, :update]
  root 'init_pages#first'
  get 'init_pages/first'
#get 'init_pages/policy'
  get 'policy', to: 'init_pages#policy' 
end

#clean up routes ** improve loading times