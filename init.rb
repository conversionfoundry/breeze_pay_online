Breeze.hook :admin_menu do |menu, user|
  menu << { :name => "Payments", :path => "/admin/payments" }
end

require 'configuration'
