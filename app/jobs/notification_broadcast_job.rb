class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform reaction, destroy = false
    ActionCable.server.broadcast "notification_channel",
     notification: render_notification(reaction),
     reaction: reaction, destroy: destroy
  end

  private

  def render_notification reaction
    ApplicationController.renderer.render(partial: "shared/notification", locals: { reaction: reaction })
  end
end
