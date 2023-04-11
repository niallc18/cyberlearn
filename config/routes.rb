Rails.application.routes.draw do
  devise_for :users
  resources :admissions do
    get :admitted_students, on: :collection
  end
  resources :courses do
    get :registered, :my_courses, :not_approved, on: :collection
    member do
      patch :approve
      patch :revoke
    end
    resources :lessons
    resources :admissions, only: [:new, :create]
  end
  resources :users, only: [:index, :edit, :show, :update]
  root 'init_pages#first'
  get 'init_pages/first'
#get 'init_pages/policy'
  get 'policy', to: 'init_pages#policy' 
end

#clean up routes ** improve loading times