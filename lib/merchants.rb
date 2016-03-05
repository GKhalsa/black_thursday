class Merchant
  attr_accessor :name, :id, :merchant_repo

  def initialize(hash, merchant_repo = nil) #{:name => 'hello', :id => 123242}
    @name = hash[:name]
    @id = hash[:id]
    @merchant_repo = merchant_repo
  end

  def items
    merchant_repo.items_from_item_repo.find_all do |item|
      item.merchant_id == id
    end
  end

  def invoices
    merchant_repo.invoices_from_invoice_repo.find_all do |invoice|
      invoice.merchant_id == id
    end
  end

  def customers
    customers = merchant_repo.customers_from_customer_repo
    invoices.map do |invoice|
      customers.find do |customer|
        customer.id == invoice.customer_id
      end
    end
  end

end
