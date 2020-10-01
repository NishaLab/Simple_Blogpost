class CreateReactions < ActiveRecord::Migration[6.0]
  def change
    create_table :reactions do |t|
      t.integer :user_id
      t.integer :post_id
      t.integer :image_id

      t.timestamps
    end
  end
end
