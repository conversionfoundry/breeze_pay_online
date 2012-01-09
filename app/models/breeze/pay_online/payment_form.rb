module Breeze
  module PayOnline
    class PaymentForm < Breeze::ApplyOnline::ApplicationPage

      field_group :payment_details do
        string_field :customer_name,  :label => "My name is",       :validate => true
        string_field :email,          :label => "My email is",      :validate => true
        string_field :reference,      :label => "My reference is",  :validate => true
        string_field :amount,         :label => "I'm paying",       :validate => true
      end


      def render!
        if request.post?
          if request.params[:next_button] && next?
            if valid?
              data[:_step] = self.next.name
              save_data_to controller.session
              unless self.next.next?
                payment = Payment.new :name => request.params[:form][:customer_name],
                                :email => request.params[:form][:email],
                                :reference => request.params[:form][:reference],
                                :amount => request.params[:form][:amount]
                payment.pxpay_urls = {
                  :url_success => 'http://www.example.com/success',
                  :url_failure => 'http://www.example.com/success'
                }
                if payment.save and payment.redirect_url.present?
                  controller.redirect_to payment.redirect_url and return
                else
                  # TODO: record error messages
                  Rails.logger.debug payment.errors.to_yaml
                  data[:_step] = self.name
                end
              end
              controller.redirect_to form.permalink and return false
            end
          elsif request.params[:back_button] && previous?
            data[:_step] = self.previous.name
            save_data_to controller.session
            controller.redirect_to form.permalink and return false
          end
        end
        Rails.logger.debug 'here'
        Breeze::Content::PageView.instance_method(:render!).bind(self).call
        Rails.logger.debug 'and here'
        #super # this could be problematic
      end

    end
  end
end
