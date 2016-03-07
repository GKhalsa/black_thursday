require 'csv'
require_relative 'invoice_item'
require 'bigdecimal'
require 'pry'
require_relative 'loader'

class InvoiceItemRepository
  attr_reader :invoice_item_array, :sales_engine

  def initialize(sales_engine)
    @invoice_item_array = []
    @sales_engine ||= sales_engine
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
    if invoice_item_array.empty?
      contents = FileLoader.load_csv(invoice_item_file)
      csv_contents_parser(contents)
    end
  end

  def instance_generator(data)
    @invoice_item_array << InvoiceItem.new({
                   id: data[0], item_id: data[1],
                   invoice_id: data[2], quantity: data[3],
                   unit_price: data[4], created_at: data[5],
                   updated_at: data[6]},self)
  end

  def csv_contents_parser(contents)
    contents.each do |row|
      data = []
      data << row[:id].to_i
      data << row[:item_id].to_i
      data << row[:invoice_id].to_i
      data << row[:quantity].to_i
      data << BigDecimal.new(row[:unit_price])/100
      data << Time.parse(row[:created_at])
      data << Time.parse(row[:updated_at])
      instance_generator(data)
    end
  end

end
