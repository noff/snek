class NotifyMailer < ApplicationMailer

  def stripe
    mail to: Rails.application.credentials.notification_email,
         subject: 'Stripe Event',
         body: params[:event],
         content_type: 'text/plain'
  end

end
