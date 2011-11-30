Rails.application.routes.draw do
  devise_for :admin, :class_name => "Breeze::Admin::User"

  scope :path => '/admin', :module => "breeze/pay_online/admin" do
    resources :payments, :only => :index
  end

  scope :module => 'breeze/pay_online', :as => 'breeze_pay_online' do
    resources :payments, :except => [:index, :delete] do
      member do
        get :pxpay_failure
        get :pxpay_success
      end
    end
  end
end
