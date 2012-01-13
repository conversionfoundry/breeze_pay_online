Installation
============

In your `config/giternal.yml`:

    breeze_pay_online:
      repo: git@github.com:leftclick/breeze_pay_online.git
      path: vendor/plugins

In your `Gemfile`:

    gem "pxpay"

And finally, in `config/initializers/forms.rb`:

    Breeze::Content.register_class Breeze::PayOnline::PaymentPage