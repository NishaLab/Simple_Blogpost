class Message < ApplicationRecord
  resourcify
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  validates :sender_id, presence: true
  validates :receiver_id, presence: true

  scope :current_user_messages, ->(user_id) { where(sender_id: user_id).or(self.where(receiver_id: user_id))}

end

