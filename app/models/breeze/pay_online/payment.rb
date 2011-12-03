module Breeze
  module PayOnline
    class Payment
      include Mongoid::Document
      include Mongoid::Timestamps

      field :name
      field :email
      field :amount
      field :reference
      field :succeded

      attr_accessor :connect_now
      attr_accessor :process_now
      attr_accessor :pxpay_urls

      validates_presence_of :name
      validates_presence_of :email
      validates_presence_of :reference
      validates_numericality_of :amount

      def redirect_url
        @redirect_url ||= pxpay_request.url rescue add_gateway_error
      end

    private

      def pxpay_request
        setup_credentials
        Pxpay::Request.new(pxpay_id, amount.to_f, pxpay_options)
      end

      def pxpay_options
        Hash.new.merge(pxpay_urls).merge(:merchant_reference => reference)
      end

      # NB: Make new transaction id for every time we attempt to connect
      def pxpay_id
        Time.now.to_i
      end

      def setup_credentials
        Pxpay::Base.pxpay_user_id = Breeze.config.pxpay_user_id
        Pxpay::Base.pxpay_key     = Breeze.config.pxpay_key
      end

      def add_gateway_error
        errors.add :base, "Couldn't connect to payment server. Please try again later."
        nil
      end

    end
  end
end
