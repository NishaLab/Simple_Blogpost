require "csv"

class ExportCsvService
  def export_posts user_id
    @objects = Micropost.recent_posts(user_id)
    @attributes = Micropost::MICROPOST_ATTRIBUTES
    @header = attributes.map { |attr| I18n.t("header_csv.#{attr}") }
    perform
  end

  def export_followers user_id
    @objects = Relationship.followers(user_id)
    @attributes = Relationship::FOLLOWER_ATTRIBUTES
    @header = attributes.map { |attr| I18n.t("header_csv.#{attr}") }
    perform
  end

  def export_followings user_id
    @objects = Relationship.followings(user_id)
    @attributes = Relationship::FOLLOWING_ATTRIBUTES
    @header = attributes.map { |attr| I18n.t("header_csv.#{attr}") }
    perform
  end

  def perform
    CSV.generate do |csv|
      csv << @header
      @objects.each do |object|
        csv << @attributes.map { |attr| object.public_send(attr) }
      end
    end
  end

  attr_reader :attributes, :objects
end
