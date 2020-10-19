class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(reaction)
    ActionCable.server.broadcast 'notification_channel', notification: render_notification(reaction)
  end
  private

  def render_notification(reaction)
    ApplicationController.renderer.render(partial: 'shared/notification', locals: { reaction: reaction })
  end
end
