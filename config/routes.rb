Rails.application.routes.draw do

  root "init_pages#first"
  get "first", to: "init_pages#first"
  get "policy", to: "init_pages#policy"
  get "contact", to: "init_pages#contact"
  devise_for :users, :controllers => { registrations: "registrations", sessions: "sessions"}
  resources :users, only: [:index, :edit, :show, :update]
  resources :courses do
    get :trending, :registered, :my_courses, :not_approved, on: :collection
    member do
      patch :approve
      patch :revoke
    end
    resources :lessons
    resources :assessments
    resources :admissions, only: [:new, :create]
  end
  resources :admissions do
    get :admitted_students, on: :collection
  end
  resources :posts do
    resources :messages, except: [:index]
  end
  resources :video, only: [:show, :update]
  
end

