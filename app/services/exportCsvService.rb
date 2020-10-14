require "csv"

class ExportCsvService
  def initialize objects, attributes
    @attributes = attributes
    @objects = objects
    @header = attributes.map { |attr| "header_csv.#{attr}" }
    binding.pry
  end

  def perform
    binding.pry
    CSV.generate do |csv|
      csv << @header
      @objects.each do |object|
        csv << @attributes.map{ |attr| object.public_send(attr) }
      end
    end
  end

  private
  attr_reader :attributes, :objects
end
