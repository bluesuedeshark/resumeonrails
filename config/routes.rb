Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"
  get "timeline" => "pages#timeline"
  get "print" => "pages#print"
  get "carline" => "carline#index"
  get "carline/export" => "carline#export"
  get "carline/report" => "carline#report", as: :carline_report
  get "carline/play" => "carline#play"
  get "categories/:id" => "categories#show", as: :category
end
