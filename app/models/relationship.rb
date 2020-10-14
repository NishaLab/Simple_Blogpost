# frozen_string_literal: true

class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  CSV_ATTRIBUTES = %w(follower_name created_at).freeze

  def follower_name
    self.follower.name
  end
end
