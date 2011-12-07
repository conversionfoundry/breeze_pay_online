module Breeze
  module PayOnline
    class Payment
      include Mongoid::Document
      include Mongoid::Timestamps

      field :name
      field :email
      field :amount
      field :reference
      field :succeeded, type: Boolean
      field :receipt_delivered, type: Boolean
      field :pxpay_response, type: Hash

      attr_accessor :connect_now
      attr_accessor :process_now
      attr_accessor :pxpay_urls

      validates_presence_of :name
      validates_presence_of :email
      validates_format_of :email, :with => /@.*?\./
      validates_presence_of :reference
      validates_numericality_of :amount

      alias_attribute :customer_name, :name
      alias_attribute :customer_email, :email

      before_save :deliver_receipt, :if => [:succeeded, :receipt_undelivered?]

      def redirect_url
        @redirect_url ||= pxpay_request.url rescue add_gateway_error
      end

      def admin_email
        Breeze.config.pxpay_receipt_from
      end

      def subject
        Breeze.config.pxpay_receipt_subject
      end

      def update_pxpay_attributes(params)
        self.pxpay_response = Pxpay::Response.new(params).response.to_hash rescue {}
        save
      end

      def pxpay_response
        read_attribute :pxpay_response or Hash.new
      end

      def obfuscated_card_number
        pxpay_response.symbolize_keys[:card_number]
      end

      def pxpay_response_text
        pxpay_response.symbolize_keys[:response_text]
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

      def receipt_undelivered?
        not receipt_delivered
      end

      def deliver_receipt
        PaymentMailer.receipt_email(self).deliver and self.receipt_delivered = true
      end

    end
  end
end
