module Breeze
  module PayOnline
    class Engine < ::Rails::Engine
      #include Breeze::Engine

      isolate_namespace Breeze::PayOnline


      config.to_prepare do
        ApplicationController.helper Breeze::PayOnline::ContentsHelper
        Breeze::Content.register_class Breeze::PayOnline::PaymentForm

      end

    end
  end
end

