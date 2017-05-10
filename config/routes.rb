Rails.application.routes.draw do
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    get "home/index"
    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".

    # You can have the root of your site routed with "root"
    root to: 'home#index'
    get 'home/newquote' => "home#newquote"
    get 'home/agservice' => "home#agservice"
    post 'quote/hours' => "quote#hours", defaults: { format: 'js' }
    post 'quote/createsow' => "quote#createsow", format: 'docx'
    get 'home/idmadminservice' => "home#idmadminservice"
    get 'home/mserviceag' => "home#mserviceag"
    get 'home/mserviceida' => "home#mserviceida"
    get 'queue/loadqueue' => "queue#loadqueue"

end
