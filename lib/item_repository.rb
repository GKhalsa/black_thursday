require "csv"
require_relative "item"

class ItemRepository
  def initialize
    @items = []
  end

  def load_csv(items_file)
    contents = CSV.open ".#{items_file}", headers: true, header_converters: :symbol
    contents.each do |row|
      name = row[:name]
      description = row[:description]
      unit_price = row[:unit_price]
      created_at = row[:created_at]
      updated_at = row[:updated_at]
      items << Item.new({:name => name, :description => description, :unit_price => unit_price, :created_at => created_at, :updated_at => updated_at})
    end
  end
end
