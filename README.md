Installation
============

In your `config/giternal.yml`:

    breeze_pay_online:
      repo: git@github.com:leftclick/breeze_pay_online.git
      path: vendor/plugins

In your `Gemfile`:

    gem "pxpay", "0.2.6"

Then run: 

And finally, in `config/initializers/forms.rb`:

    Breeze::Content.register_class Breeze::PayOnline::PaymentPage

Don't forget to run `giternal update` and `bundle install` after these changes!