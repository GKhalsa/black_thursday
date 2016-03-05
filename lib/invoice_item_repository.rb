require 'csv'
require_relative 'invoice_item'
require 'bigdecimal'
require 'pry'

class InvoiceItemRepository
  def initialize(sales_engine)
    @invoice_item_array = []
    @sales_engine ||= sales_engine
  end

  def searching_for_merchants
    sales_engine.merchants.merchant_array
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
  end






  def load_csv(invoice_item_file)
    contents = CSV.open "#{invoice_item_file}", headers: true, header_converters: :symbol
    contents.each do |row|
      # @invoice_array << Invoice.new(row)

      id = row[:id].to_i
      item_id = row[:item_id].to_i
      invoice_id = row[:invoice_id].to_i
      quantity = row[:quantity].to_i
      unit_price = BigDecimal.new(row[:unit_price])/100
      created_at = Time.parse(row[:created_at])
      updated_at = Time.parse(row[:updated_at])

      @invoice_item_array << InvoiceItem.new({id: id, item_id: item_id, invoice_id: invoice_id, quantity: quantity, unit_price: unit_price, created_at: created_at, updated_at: updated_at})
    end
  end

end
