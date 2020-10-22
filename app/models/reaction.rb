class Reaction < ApplicationRecord
  after_create_commit {
    NotificationBroadcastJob.perform_later(self)
  }
  scope :all_notification, ->(user_id) {
    post_ids = Micropost.where(user_id: user_id).pluck(:id)
    self.where(micropost_id: post_ids)
  }
  scope :all_unread_notification, ->(user_id) {
    post_ids = Micropost.where(user_id: user_id).pluck(:id)
    self.where(micropost_id: post_ids, is_read: false)
  }
  belongs_to :user
  belongs_to :micropost
  validates :user_id, presence: true
  validates :micropost_id, presence: true
end
