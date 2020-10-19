class Reaction < ApplicationRecord
  after_create_commit {
    NotificationBroadcastJob.perform_later(self)
  }
  belongs_to :user
  belongs_to :micropost
  validates :user_id, presence: true
  validates :micropost_id, presence: true
end
