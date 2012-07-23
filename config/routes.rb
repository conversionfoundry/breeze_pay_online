Breeze::Engine.routes.draw do
  namespace "admin" do
  	 namespace "pay_online" do
	    # scope "admin/customers", :module => "breeze/account", :name_prefix => "admin_customers" do
	    resources :payments, :only => :index
	  end
  end

  # devise_for :customers, :class_name => "Breeze::Account::Customer"
end



# Rails.application.routes.draw do
#   devise_for :admin, :class_name => "Breeze::Admin::User"

#   scope :path => '/admin', :module => "breeze/pay_online/admin" do
#     resources :payments, :only => :index
#   end

# end
