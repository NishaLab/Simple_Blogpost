# frozen_string_literal: true

class AddResetPasswordToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :reset_digest, :string
    add_column :users, :reset_at, :datetime
  end
end
