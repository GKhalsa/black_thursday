require "csv"
require_relative "item"
require 'pry'
require 'bigdecimal'
require 'time'

class ItemRepository
  attr_reader :item_array, :sales_engine

  def initialize(sales_engine)
    @item_array = []
    @sales_engine ||= sales_engine
  end

  def searching_for_merchants(merchant_id)
    sales_engine.merchants.merchant_array.find do |merchant|
      merchant.id == merchant_id
    end
  end

  def inspect
    "#<#{self.class} #{@item_array.size} rows>"
  end

  def all
    item_array
  end

  def find_by_id(id)
    item_array.find do |item|
      item.id == id
    end
  end

  def find_by_name(name)
    item_array.find do |item|
      item.name == name
    end
  end

  def find_all_with_description(description)
    item_array.find_all do |item|
      item.description.downcase.include?(description.downcase)
    end
  end

  def find_all_by_price(unit_price)
    item_array.find_all do |item|
      item.unit_price == unit_price
    end
  end

  def find_all_by_price_in_range(price_range)
    item_array.find_all do |item|
      item.unit_price >= price_range.first && item.unit_price <= price_range.last
    end
  end

  def find_all_by_merchant_id(merchant_id)
    item_array.find_all do |item|
      item.merchant_id == merchant_id
    end
  end

  def load_csv(items_file)
    if item_array.empty?
      contents = FileLoader.load_csv(items_file)
      csv_contents_loader(contents)
    end
  end

  def instance_loader(data)
    @item_array << Item.new({
        id:          data[0],
        name:        data[1],
        description: data[2],
        unit_price:  data[3],
        created_at:  data[4],
        updated_at:  data[5],
        merchant_id: data[6]}, self)
  end

  def csv_contents_loader(contents)
    contents.each do |row|
      data = []
      data << row[:id].to_i
      data << row[:name]
      data << row[:description]
      data << BigDecimal.new(row[:unit_price])/100
      data << Time.parse(row[:created_at])
      data << Time.parse(row[:updated_at])
      data << row[:merchant_id].to_i
      instance_loader(data)
    end
  end

end
