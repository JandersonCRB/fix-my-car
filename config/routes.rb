Rails.application.routes.draw do
  resources :fixes, except: [:edit, :update] do
  	resource :reviews, only: [:create, :new, :destroy]
  	member do
  		put 'attend'
  	end
  end
  resources :users, only: [:show]
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => redirect('/fixes/new')
end
