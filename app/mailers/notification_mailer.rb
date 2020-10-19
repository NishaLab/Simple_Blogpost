class NotificationMailer < ApplicationMailer
  def new_notification reaction
    @reaction = reaction
    mail(to: reaction.user.email, subject: "You got a new notification!")
  end
end
