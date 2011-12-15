module Breeze
  module PayOnline
    class PaymentForm < Breeze::ApplyOnline::ApplicationPage

      field_group :payment_details do
        string_field :customer_name,  :label => "My name is",       :validate => true
        string_field :email,          :label => "My email is",      :validate => true
        string_field :reference,      :label => "My reference is",  :validate => true
        string_field :amount,         :label => "I'm paying",       :validate => true
      end


      def render!
        if request.post?
          if request.params[:next_button] && next?
            if valid?
              data[:_step] = self.next.name
              save_data_to controller.session
              unless self.next.next?
                # TODO: I think we need to overwrite this bit
                application = form.application_class.factory(self)
                application.save
              end
              controller.redirect_to form.permalink and return false
            end
          elsif request.params[:back_button] && previous?
            data[:_step] = self.previous.name
            save_data_to controller.session
            controller.redirect_to form.permalink and return false
          end
        end
        
        super # this could be problematic
      end

    end
  end
end
