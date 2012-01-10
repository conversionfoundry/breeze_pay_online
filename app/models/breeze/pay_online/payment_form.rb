module Breeze
  module PayOnline
    class PaymentForm < Breeze::ApplyOnline::ApplicationPage

      attr_accessor :payment

      field_group :payment_details do
        string_field :customer_name,  :label => "My name is",       :validate => true
        string_field :email,          :label => "My email is",      :validate => true
        string_field :reference,      :label => "My reference is",  :validate => true
        string_field :amount,         :label => "I'm paying",       :validate => true
      end

      def pxpay_url
        request.protocol + request.host_with_port + form.permalink + '/' + @payment.id.to_s
      end

      def pxpay_success
        @payment.update_pxpay_attributes request.params
        data[:_step] = self.next.name
        controller.redirect_to form.permalink
      end

      def pxpay_failure
        @payment.update_pxpay_attributes request.params
        errors.add :base, "Couldn't process payment. Please try again."
        errors.add :base, "The payment server responded: #{@payment.pxpay_response_text}" if @payment.pxpay_response_text
      end

      def redirectable?
        @payment.pxpay_urls = pxpay_urls
        @payment.redirect_url.present?
      end

      def pxpay_urls
        {
          :url_success => pxpay_url + '/pxpay_success',
          :url_failure => pxpay_url + '/pxpay_failure',
        }
      end

      def render!
        if @payment = page.payment
          @payment.succeeded? ? (pxpay_success and return) : pxpay_failure
        end
        if request.post?
          if request.params[:next_button] && next?
            if valid?
              unless self.next.next?
                @payment = Payment.new :name => request.params[:form][:customer_name],
                                :email => request.params[:form][:email],
                                :reference => request.params[:form][:reference],
                                :amount => request.params[:form][:amount]
                if @payment.save and redirectable?
                  controller.redirect_to @payment.redirect_url and return
                else
                  @payment.errors.each { |attrib, err| errors.add attrib, err }
                  Rails.logger.debug @payment.errors.to_yaml
                end
              else
                data[:_step] = self.next.name
                save_data_to controller.session
                controller.redirect_to form.permalink and return false
              end
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
