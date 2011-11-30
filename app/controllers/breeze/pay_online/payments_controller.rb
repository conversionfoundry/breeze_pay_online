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
        #response = Pxpay::Response.new(params).response
        #render :text => response.to_hash.to_yaml
        @payment.update_attributes :succeded => true
        redirect_to @payment
      end

      def pxpay_failure
        @payment.errors.add :base, "Couldn't process payment. Please try again."
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
