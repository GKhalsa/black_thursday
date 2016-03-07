require 'pry'
require 'bigdecimal'

class InvoiceItem

  attr_reader :id, :item_id, :invoice_id, :quantity, :unit_price,
              :created_at, :updated_at, :invoice_item_repo

  def initialize(invoice_item_data, invoice_item_repo = nil)
    @id = invoice_item_data[:id]
    @item_id = invoice_item_data[:item_id]
    @invoice_id = invoice_item_data[:invoice_id]
    @quantity = invoice_item_data[:quantity]
    @unit_price = invoice_item_data[:unit_price]
    @created_at = invoice_item_data[:created_at]
    @updated_at = invoice_item_data[:updated_at]
    @invoice_item_repo = invoice_item_repo
  end

  def find_item
    invoice_item_repo.items_from_item_repo(item_id)
  end

end
