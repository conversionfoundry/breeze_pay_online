Rails.application.routes.draw do
  devise_for :admin, :class_name => "Breeze::Admin::User"

  scope "admin", :name_prefix => "admin", :module => "breeze/pay_online" do
    resources :payments
  end
end