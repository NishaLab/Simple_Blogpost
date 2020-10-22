class AddReadNotificationToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :read_notification, :boolean, default: false
  end
end
