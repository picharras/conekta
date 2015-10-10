Rails.application.routes.draw do
  
  resources :cards, defaults: { format: :json }, :only => [:create]
  resources :charges, defaults: { format: :json }, :only => [:create]

end
