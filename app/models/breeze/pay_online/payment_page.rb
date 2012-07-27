module Breeze
  module PayOnline
    PERMALINK = /\/(\w+)\/(pxpay_success|pxpay_failure)/

    class PaymentPage < Breeze::ApplyOnline::ApplicationPage

      attr_accessor :payment

      def self.find_by_permalink(permalink)
        Rails.logger.debug "find_by_perm".red
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

    end
  end
end
