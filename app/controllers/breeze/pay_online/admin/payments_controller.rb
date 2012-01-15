module Breeze
  module PayOnline
    module Admin
      class PaymentsController < Breeze::Admin::AdminController
        def index
          @payments = Payment.desc(:created_at).paginate :per_page => 20, :page => params[:page]
        end
      
        def show
          @payment = Breeze::PayOnline::Payment.find params[:id]
          render :layout => "enquiry"
        end
      
      end
    end
  end
end
