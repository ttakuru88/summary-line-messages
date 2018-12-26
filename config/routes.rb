Rails.application.routes.draw do
  root 'summaries#new'

  resources :summaries, only: [:new, :create, :show]
end
