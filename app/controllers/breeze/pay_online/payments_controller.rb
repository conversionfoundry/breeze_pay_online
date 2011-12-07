module Breeze
  module PayOnline
    class PaymentsController < ApplicationController

      before_filter :find_payment, :only => [:edit, :update, :pxpay_success, :pxpay_failure, :show]

      def new
        @payment = Payment.new
      end

      def create
        @payment = Payment.new params[:breeze_pay_online_payment]
        if @payment.save and redirectable?
          redirect_to @payment.redirect_url
        else
          render :new
        end
      end

      def update
        if @payment.update_attributes params[:breeze_pay_online_payment] and redirectable?
          redirect_to @payment.redirect_url
        else
          render :new
        end    
      end

      def pxpay_success
        @payment.succeeded = true
        @payment.update_pxpay_attributes params
        redirect_to @payment
      end

      def pxpay_failure
        @payment.update_pxpay_attributes params
        @payment.errors.add :base, "Couldn't process payment. Please try again."
        @payment.errors.add :base, "The payment server responded: #{@payment.pxpay_response_text}" if @payment.pxpay_response_text
        render :edit
      end

    private

      def find_payment
        @payment = Payment.find params[:id]
      end

      def redirectable?
        @payment.pxpay_urls = pxpay_urls
        @payment.redirect_url.present?
      end

      def pxpay_urls
        {
          :url_success => pxpay_success_breeze_pay_online_payment_url(@payment),
          :url_failure => pxpay_failure_breeze_pay_online_payment_url(@payment)
        }
      end

    end
  end
end
