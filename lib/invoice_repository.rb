require "csv"
require_relative "invoice"
require 'pry'
require 'bigdecimal'
require 'time'
require_relative 'loader'

class InvoiceRepository
  attr_reader :invoice_array, :sales_engine

  def initialize(sales_engine)
    @invoice_array = []
    @sales_engine ||= sales_engine
  end

  def merchants_from_merch_repo
    sales_engine.merchants.merchant_array
  end

  def transactions_from_transaction_repo
    sales_engine.transactions.transaction_array
  end

  def customers_from_customer_repo
    sales_engine.customers.customer_array
  end

  def invoice_items_from_inv_item_array
    sales_engine.invoice_items.invoice_item_array
  end

  def all
    invoice_array
  end

  def find_by_id(id)
    invoice_array.find do |invoice|
      invoice.id == id
    end
  end

  def find_all_by_customer_id(customer_id)
    invoice_array.find_all do |invoice|
      invoice.customer_id == customer_id
    end
  end

  def find_all_by_merchant_id(merchant_id)
    invoice_array.find_all do |invoice|
      invoice.merchant_id == merchant_id
    end
  end

  def find_all_by_status(status)
    invoice_array.find_all do |invoice|
      invoice.status == status
    end
  end

  def inspect
    "#<#{self.class} #{@invoice_array.size} rows>"
  end

  def load_csv(invoice_file)
    if invoice_array.empty?
      contents = FileLoader.load_csv(invoice_file)
      csv_contents_parser(contents)
    end
  end

  def instance_generator(data)
    @invoice_array << Invoice.new({
              id: data[0], customer_id: data[1],
              merchant_id: data[2], status: data[3],
              created_at: data[4], updated_at: data[5]}, self)
  end

  def csv_contents_parser(contents)
    contents.each do |row|
      data = []
      data << row[:id].to_i
      data << row[:customer_id].to_i
      data << row[:merchant_id].to_i
      data << row[:status].to_sym
      data << Time.parse(row[:created_at])
      data << Time.parse(row[:updated_at])
      instance_generator(data)
    end
  end

end
