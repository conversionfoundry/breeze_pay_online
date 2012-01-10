module Breeze
  module PayOnline
    PERMALINK = /\/(\w+)\/(pxpay_success|pxpay_failure)/

    class PaymentPage < Breeze::ApplyOnline::ApplicationForm

      attr_accessor :payment

      def self.find_by_permalink(permalink)
        if permalink =~ Breeze::PayOnline::PERMALINK
          permalink = $`
          page = where(:permalink => permalink).first
          if page.present?
            payment = Payment.find $1
            payment.succeeded = true if $2 == 'pxpay_success'
            page.payment = payment
          end
          return page
        end
      end



    protected

      def define_form_pages
        views.build({ :name => "payment_details", :title => "Payment details" }, PaymentForm).name = "payment_details"
        super # confirmation page, etc
      end

    end
  end
end
