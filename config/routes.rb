Walleet::Application.routes.draw do
  devise_for :people

  namespace :api do
    namespace :v1 do
      resources :groups do
        member do
          get :feed
        end
      end
      resources :memberships
      resources :debts
      resources :undos
      resource :people, :path => "me" do
        member do
          get "related"
          get "feed"
        end
      end
    end
  end

  match "*anything" => "home#index"
  root :to => 'home#index'
end
