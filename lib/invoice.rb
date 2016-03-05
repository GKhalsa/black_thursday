require 'pry'
require_relative 'invoice_repository'

class Invoice
  attr_reader :id, :customer_id, :merchant_id, :status,
              :created_at, :updated_at, :invoice_repo

  def initialize(invoice_data, invoice_repo = nil)
    @id = invoice_data[:id]
    @customer_id = invoice_data[:customer_id]
    @merchant_id = invoice_data[:merchant_id]
    @status = invoice_data[:status]
    @created_at = invoice_data[:created_at]
    @updated_at = invoice_data[:updated_at]
    @invoice_repo = invoice_repo
  end

  def merchant
    invoice_repo.merchants_from_merch_repo.find_all do |merchant|
      merchant.id == merchant_id
    end[0]
  end

  def items
    invoice_item_objects = invoice_repo.sales_engine.invoice_items.invoice_item_array
    matching_invoice_items = invoice_item_objects.find_all do |invoice_item|
      invoice_item.invoice_id == id
    end

    x = matching_invoice_items.map do |invoice_item|
      invoice_item.find_item
    end
  end

  def transactions
    x = invoice_repo.transactions_from_transaction_repo.find_all do |transaction|
      transaction.invoice_id == id
    end
  end

  def customer
    x = invoice_repo.customers_from_customer_repo.find do |customer|
    customer.id == customer_id
    end
  end

end
