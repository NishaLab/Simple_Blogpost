# frozen_string_literal: true

class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'Users'
  belongs_to :followed, class_name: 'Users'
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
