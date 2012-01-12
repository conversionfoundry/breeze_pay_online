Rails.application.routes.draw do
  devise_for :admin, :class_name => "Breeze::Admin::User"

  scope :path => '/admin', :module => "breeze/pay_online/admin" do
    resources :payments, :only => :index
  end

end
