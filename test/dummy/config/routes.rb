Rails.application.routes.draw do
  mount Workarea::Core::Engine => '/'
  mount Workarea::Api::Engine => '/api', as: 'api'
  mount Workarea::Admin::Engine => '/admin', as: 'admin'
  mount Workarea::Storefront::Engine => '/', as: 'storefront'
end
