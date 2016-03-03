require "csv"
require_relative "item"
require 'pry'
require 'bigdecimal'

class ItemRepository
  attr_reader :items, :sales_engine
  def initialize(sales_engine)
    @items = []
    @sales_engine ||= sales_engine
  end

  def searching_for_merchants
    sales_engine.merchants.merchants
  end

  def inspect
    "#<#{self.class} #{@items.size} rows>"
  end

  def load_csv(items_file)
    contents = CSV.open "#{items_file}", headers: true, header_converters: :symbol
    contents.each do |row|
      id = row[:id].to_i
      name = row[:name]
      description = row[:description]
      unit_price = BigDecimal.new(row[:unit_price].to_i/100)
      created_at = Time.new(row[:created_at])
      updated_at = Time.new(row[:updated_at])
      merchant_id = row[:merchant_id].to_i
      @items << Item.new({:id => id, :name => name, :description => description, :unit_price => unit_price, :created_at => created_at, :updated_at => updated_at, :merchant_id => merchant_id}, self)
    end
  end

  def all
    items
  end

  def find_by_id(id)
    items.find do |item|
      item.id == id
    end
  end

  def find_by_name(name)
    items.find do |item|
      item.name == name
    end
  end

  def find_all_with_description(description)
    items.find_all do |item|
      item.description.downcase.include?(description.downcase)
    end
  end

  def find_all_by_price(unit_price)
    items.find_all do |item|
      item.unit_price == unit_price
    end
  end

  def find_all_by_price_in_range(price_range)
    items.find_all do |item|
      price_range.find do |price|
        item.unit_price == price
      end
    end
  end

  def find_all_by_merchant_id(merchant_id)
    items.find_all do |item|
      item.merchant_id == merchant_id
    end
  end
end
