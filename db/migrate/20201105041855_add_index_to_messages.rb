class AddIndexToMessages < ActiveRecord::Migration[6.0]
  def change
    add_index :messages, :sender_id
    add_index :messages, :receiver_id
  end
end
