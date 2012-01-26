Breeze.hook :admin_menu do |menu, user|
  menu << { :name => "Payments", :path => "/admin/payments" }
end

Breeze.hook :get_content_by_permalink do |permalink_or_content|
  Rails.logger.debug "get_content".red
  Rails.logger.debug permalink_or_content.class.to_s.red
  case permalink_or_content
  when Breeze::Content::Item then permalink_or_content
  when String then Breeze::PayOnline::PaymentPage.find_by_permalink(permalink_or_content) || permalink_or_content
  else permalink_or_content
  end
end

require 'configuration'
