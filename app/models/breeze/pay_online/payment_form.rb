module Breeze
  module PayOnline
    class PaymentForm < ApplyOnline::ApplicationForm

      def application_class
        Payment
      end

    protected

      def define_form_pages
        views.build({ :name => "payment_page", :title => "Your details" }, PaymentPage).name = "payment_page"
        super # confirmation page, etc
      end      

    end
  end
end