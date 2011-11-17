module Breeze
  module PayOnline
    class PaymentsController < Breeze::Admin::AdminController
      def index
        @payments = Breeze::PayOnline::Payment.desc(:created_at).paginate :per_page => 20, :page => params[:page]
      end
      
      def show
        @payment = Breeze::PayOnline::Payment.find params[:id]
        render :layout => "enquiry"
      end
      
    end
  end
end
