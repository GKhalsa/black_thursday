require "csv"
require_relative "invoice"
require 'pry'
require 'bigdecimal'
require 'time'

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
    contents = CSV.open "#{invoice_file}", headers: true, header_converters: :symbol
    contents.each do |row|
      # @invoice_array << Invoice.new(row)

      id = row[:id].to_i
      customer_id = row[:customer_id].to_i
      merchant_id = row[:merchant_id].to_i
      status = row[:status].to_sym
      created_at = Time.parse(row[:created_at])
      updated_at = Time.parse(row[:updated_at])

      @invoice_array << Invoice.new({id: id, customer_id: customer_id, merchant_id: merchant_id, status: status, created_at: created_at, updated_at: updated_at}, self)
    end
  end
end
