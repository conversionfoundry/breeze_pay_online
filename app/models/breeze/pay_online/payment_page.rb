module Breeze
  module PayOnline
    class PaymentPage < Breeze::ApplyOnline::ApplicationForm

    protected

      def define_form_pages
        views.build({ :name => "payment_details", :title => "Payment details" }, PaymentForm).name = "payment_details"
        super # confirmation page, etc
      end

    end
  end
end
