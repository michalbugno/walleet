Walleet::Application.routes.draw do
  scope :api do
    scope :v1 do
      devise_for :people, :skip => ["session", "registration", "password"], :name => "person", :path => "person"
      devise_scope :person do
        post "api/v1/person" => "devise/registrations#create"
        put "api/v1/person" => "devise/registrations#update"
        delete "api/v1/person" => "devise/registrations#destroy"

        post "api/v1/person/sign_in" => "devise/sessions#create"
        delete "api/v1/person/sign_out" => "devise/sessions#destroy"

        post "api/v1/person/password" => "devise/passwords#create"
        put "api/v1/person/password" => "devise/passwords#update"
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :groups, :only => ["index", "show", "create", "update", "destroy"] do
        member do
          get :feed
        end
      end
      resources :memberships, :only => ["create", "destroy"]
      resources :debts, :only => ["create"]
      resources :undos, :only => ["destroy"]
      resource :person, :controller => "people", :only => ["show"] do
        member do
          get "related"
          get "feed"
        end
      end
    end
  end

  match "*path" => "home#index"
  root :to => 'home#index'
end
