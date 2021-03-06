# frozen_string_literal: true

# dasdasda
class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable,
         :omniauthable, omniauth_providers: %i(github facebook google_oauth2)

  attr_accessor :remember_token, :activation_token, :reset_token
  scope :recent_posts, ->(user_id) { where(user_id: user_id, parent_id: nil).where("created_at > ?", 1.month.ago) }
  scope :new_users, -> { where("created_at BETWEEN ? AND ?", 1.day.ago.beginning_of_day, 1.day.ago.end_of_day) }
  before_save { self.email = email.downcase }
  before_create :create_activation_digest

  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :reactions, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  # has_secure_password

  def self.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def create_reset_digest
    raw, hash = Devise.token_generator.generate(User, :reset_password_token)
    self.reset_token = raw
    update_attribute(:reset_password_token, hash)
    update_attribute(:reset_password_sent_at, Time.zone.now)
  end

  def password_reset_expired?
    reset_password_sent_at < 2.hours.ago
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id AND parent_id IS :parent_id",
                    user_id: id, parent_id: nil)
  end

  def follow other_user
    following << other_user
  end

  def following? other_user
    following.include?(other_user)
  end

  def unfollow other_user
    following.delete(other_user)
  end

  def self.from_omniauth access_token
    data = access_token.info
    # handle if user exist in database
    user = User.find_by(email: data["email"])
    # handle if user isn't exist in database
    password = SecureRandom.urlsafe_base64
    user || User.create(name: data["name"], email: data["email"],
                        password: password,
                        password_confirmation: password,
                        activated: true, activated_at: Time.zone.now,
                        confirmed_at: Time.zone.now)
  end

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
