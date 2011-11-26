module Breeze
  module PayOnline
    class PaymentPage < ApplyOnline::ApplicationPage

      field_group :transaction_details do
        string_field :your_name, :label => "My name is", :validate => true
        string_field :email, :label => "My email is", :validate => true
      end      

    end
  end
end