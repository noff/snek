class StatsMailer < ApplicationMailer
  default from: "info@snek.app"
  layout 'mailer'


  def weekly(snek)
    @snek = snek
    mail(to: @snek.user.email, subject: "#{snek.short_name} weekly stats")
  end

end
