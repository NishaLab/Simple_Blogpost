# frozen_string_literal: true

# simple micropost class has 1 attribute: content
class Micropost < ApplicationRecord
  belongs_to :user
  validates :content, length: { maximum: 140 }, presence: true
end
