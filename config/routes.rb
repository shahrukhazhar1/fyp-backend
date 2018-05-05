Rails.application.routes.draw do

  get '/quiz_admins/sign_up' => redirect('/')
  get '/quiz_users/sign_up' => redirect('/')
  get '/quiz_admins/sign_in' => redirect('/')
  get '/quiz_users/sign_in' => redirect('/')

  devise_for :quiz_admins
  devise_for :quiz_users

  namespace :api do
    namespace :v1 do
      namespace :mobile do
        resources :quiz_results, :only => [:create]
        resources :courses
        resources :quizzes do
          collection do
            get :api_quiz_results
          end
        end
      end
      resources :courses
      resources :labels

      resources :mailing_list, only: [] do
        member do
          post 'entries' => 'mailing_list#create_entry'
        end
      end

      resources :devices, :only => [:index, :show, :update] do
        member do
          get :installed_apps
        end
      end

      post 'devices/update_fcm_token', to: 'devices#update_fcm_token'

      get 'devices/show_device/:id/:device_id', to: 'devices#show_device'
      get 'devices/subscription_date/:id', to: 'devices#subscription_date'
      post 'devices/toggle', to: 'devices#toggle'

      post 'set_comment', to: 'quizzes#set_comment'
      post 'set_question_comment', to: 'questions#set_question_comment'
      post 'set_sample_question' => 'quizzes#set_sample_question'
      post 'set_switch_val' => 'quiz_creation#set_switch_val'
      get 'user_info' => 'quiz_creation#user_info'
      get 'quiz_messages' => 'quiz_creation#quiz_messages'
      get 'quiz_admin_messages'=> 'cogli_admin#quiz_admin_messages'

      post 'set_installed_apps' => 'devices'

      devise_scope :quiz_user do
        post 'register' => 'registrations#create', :as => 'register'
        post 'login' => 'sessions#create', :as => 'login'
        delete 'logout' => 'sessions#destroy', :as => 'logout'
        get 'confirmation' => 'confirmations#show'
      end

      devise_scope :quiz_admin do
        post 'signin' => 'quiz_admins/sessions#create', as: 'signin'
        delete 'signout' => 'quiz_admins/sessions#destroy', as: 'signout'
      end

      devise_scope :user do
        post 'users_signin' => 'users/sessions#create', as: 'users_signin'
        delete 'users_signout' => 'users/sessions#destroy', as: 'users_signout'
      end



      resources :users do
        collection do
          post :update_password
        end
      end

      resources :cogli_admin do
        collection do
          get :unfinished_quizzes
          get :submitted_quizzes
          get :approved_quizzes
        end
      end

      resources :quiz_creation do
        collection do
          get :tutorials
          get :rejected_quizzes
          get :approved_quizzes
          get :submitted_quizzes
          get :unfinished_quizzes
        end
      end

      resources :quizzes do
        member do
          get :approve
          get :reject
          get :new_verison
          get :submit_for_approval
          get :study_guide
        end
        collection do
          post :update_quiz
          post :add_grades
          post :update_grades
          get :get_grades
          get :quiz_results
        end
        resources :questions, :except => [:index] do
          member do
            put :change_order
          end
        end
      end
    end
  end

  resources :user_settings do
    member do
      get :unsubscribe
    end
    collection do
      post :tutorial_seen
      post :device_status
      post :check_tutorial
      post :verify_quiz_queue
    end
  end
  resources :quiz_portal

  # Added by Koudoku.
  mount Koudoku::Engine, at: 'plans'
  scope module: 'koudoku' do
    get 'pricing' => 'subscriptions#index', as: 'pricing'
  end

  devise_for :users, controllers: {
    registrations: "users/registrations",
    confirmations: "users/confirmations",
    passwords: "users/passwords"
  }

  resources :weekly_reports
  resources :devices do
    member do
      get :quiz_shopping
      get :quiz_queue
      get :weekly_report
      get :quiz_results
    end
    resources :quizzes do

      resources :questions, :except => [:index] do
        member do
          put :change_order
        end
      end

      resources :quiz_selections, :only => [:index, :create, :destroy] do
        member do
          put :change_order
        end
      end

      member do
        put :change_order
        # post :quiz_selection
      end
    end
    resources :emergency_numbers
  end
  resources :analytics, :only => [:index]

  get :account, :to => 'home#account'

  get :terms_of_service, :to => 'home#terms_of_service'
  get :privacy_policy, :to => 'home#privacy_policy'
  get :privacy_policy_tos, :to => 'home#privacy_policy_tos'

  get :all_quizzes, :to => 'quizzes#all_quizzes'

  get "device/:device_id/quiz/:quiz_id/quiz_selection", to: "quiz_selections#selection", as: :device_quiz_selection

  devise_scope :user do
    root :to => 'home#index'
  end

  devise_scope :quiz_user do
    authenticated  do
      root to: 'quiz_creation#index', as: 'authenticated_quiz_user_root'
    end
  end

  post '/toggle_app' => 'devices#toggle_app'
  post '/send_report' => 'home#send_report'
  post '/update_row_order' => 'devices#update_row_order'
  post '/update_quiz_position' => 'devices#update_quiz_position'
  post '/check_email' => 'home#check_email'
  post '/check_email_present' => 'home#check_email_present'
  post 'check_quiz_user_email' => 'quiz_portal#check_quiz_user_email'
  match '*path' => redirect('/'), via: :get
end
