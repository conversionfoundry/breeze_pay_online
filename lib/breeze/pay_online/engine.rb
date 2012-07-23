module Breeze
  module PayOnline
    class Engine < ::Rails::Engine
      #include Breeze::Engine

      isolate_namespace Breeze::PayOnline


      config.to_prepare do
        ApplicationController.helper Breeze::PayOnline::ContentsHelper
      end

    end
  end
end

