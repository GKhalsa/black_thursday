require 'pry'
require_relative 'invoice_repository'

class Invoice
  attr_reader :id, :customer_id, :merchant_id, :status,
              :created_at, :updated_at, :invoice_repo

  def initialize(invoice_data, invoice_repo = nil)
    @id           = invoice_data[:id]
    @customer_id  = invoice_data[:customer_id]
    @merchant_id  = invoice_data[:merchant_id]
    @status       = invoice_data[:status]
    @created_at   = invoice_data[:created_at]
    @updated_at   = invoice_data[:updated_at]
    @invoice_repo = invoice_repo
  end

  def merchant
    invoice_repo.merchants_from_merch_repo(merchant_id)
  end

  def items
    invoice_items.map {|invoice_item| invoice_item.find_item}
  end

  def transactions
    invoice_repo.transactions_from_transaction_repo(id)
  end

  def customer
    invoice_repo.customers_from_customer_repo(customer_id)
  end

  def is_paid_in_full?
    transactions.any? do |transaction|
      transaction.result == "success"
    end
  end

  def invoice_items
    invoice_repo.invoice_items_from_inv_item_array(id)
  end

  def total
    invoice_items.reduce(0) do |total, invoice_item|
      total += (invoice_item.unit_price * invoice_item.quantity)
    end
    #reminder
  end

end
