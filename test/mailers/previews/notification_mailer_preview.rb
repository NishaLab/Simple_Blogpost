# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def new_notification
    @react = Reaction.first
    NotificationMailer.new_notification(@react)
  end
end
