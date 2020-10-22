class AddIsReadToReaction < ActiveRecord::Migration[6.0]
  def change
    add_column :reactions, :is_read, :boolean, default: false
  end
end
