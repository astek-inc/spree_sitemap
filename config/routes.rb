Spree::Core::Engine.routes.draw do

  resources :sitemap, only: :index
  get '/sitemap.xml.gz', to: 'sitemap#index', defaults: { format: 'xml' }

end
