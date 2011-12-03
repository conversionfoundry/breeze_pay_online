class Breeze::PayOnline::PaymentMailer < ActionMailer::Base #Breeze::Mailer

  def receipt_email(payment)
    @payment = payment
    mail :to      => payment.customer_email,
         :from    => payment.admin_email,
         :bcc     => payment.admin_email,
         :subject => payment.subject
  end

end
