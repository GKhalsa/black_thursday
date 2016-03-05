require 'csv'
require_relative 'invoice_item'
require 'bigdecimal'
require 'pry'

class InvoiceItemRepository
  attr_reader :invoice_item_array

  def initialize
    @invoice_item_array = []
  end

  def searching_for_merchants
    sales_engine.merchants.merchant_array
  end

  def inspect
    "#<#{self.class} #{@invoice_item_array.size} rows>"
  end

  def all
    invoice_item_array
  end

  def find_by_id(id)
    invoice_item_array.find do |invoice_item|
      invoice_item.id == id
    end
  end

  def find_all_by_item_id(item_id)
    invoice_item_array.find_all do |invoice_item|
      invoice_item.item_id == item_id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    invoice_item_array.find_all do |invoice_item|
      invoice_item.invoice_id == invoice_id
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
