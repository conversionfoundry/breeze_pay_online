module Breeze
  module PayOnline
    class PaymentForm < Breeze::ApplyOnline::ApplicationPage

      field_group :payment_details do
        string_field :customer_name,  :label => "My name is",       :validate => true
        string_field :email,          :label => "My email is",      :validate => true
        string_field :reference,      :label => "My reference is",  :validate => true
        string_field :amount,         :label => "I'm paying",       :validate => true
      end

    end
  end
end
