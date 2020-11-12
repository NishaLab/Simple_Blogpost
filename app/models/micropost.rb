# frozen_string_literal: true

# simple micropost class has 1 attribute: content
class Micropost < ApplicationRecord
  resourcify
  MICROPOST_ATTRIBUTES = %w(content created_at).freeze
  scope :recent_posts, ->(user_id) { where(user_id: user_id, parent_id: nil).where("created_at > ?", 1.month.ago) }
  scope :new_posts, -> { where("created_at BETWEEN ? AND ?", 1.day.ago.beginning_of_day, 1.day.ago.end_of_day) }

  belongs_to :user
  belongs_to :parent_post, class_name: "Micropost", optional: true
  has_one_attached :image
  has_many :reactions, dependent: :destroy
  has_many :child_posts, class_name: "Micropost",
                   foreign_key: "parent_id", dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :content, length: { maximum: 140 }, presence: true
  validates :user_id, presence: true
  validates :image, content_type: { in: %w(image/jpeg image/gif image/png),
                                    message: "must be a valid image format" },
                    size: { less_than: 5.megabytes,
                            message: "should be less than 5MB" }

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
