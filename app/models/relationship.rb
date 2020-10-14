# frozen_string_literal: true

class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  FOLLOWER_ATTRIBUTES = %w(follower_name created_at).freeze
  FOLLOWING_ATTRIBUTES = %w(following_name created_at).freeze

  def follower_name
    self.follower.name
  end

  def following_name
    self.followed.name
  end
end
