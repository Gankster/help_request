Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :questions do
    resources :answers, shallow: true

    member do
      patch 'mark_best/:answer_id', to: 'questions#mark_best', as: :mark_best
    end
  end

  root to: "questions#index"
end
