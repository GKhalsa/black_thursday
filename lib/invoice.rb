require 'pry'
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


end
