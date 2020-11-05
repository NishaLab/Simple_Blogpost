class Message < ApplicationRecord
  resourcify
  after_create_commit {
    MessageBroadcastJob.perform_later(self)
  }
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  validates :sender_id, presence: true
  validates :receiver_id, presence: true

  scope :messages_between, ->(sender_id, receiver_id) {
      where(sender_id: sender_id, receiver_id: receiver_id)
        .or(self.where(sender_id: receiver_id, receiver_id: sender_id))
    }
end
