class Merchant
  attr_accessor :name, :id, :merchant_repo

  def initialize(hash, merchant_repo = nil)
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
    hash = {}
    customers = merchant_repo.customers_from_customer_repo
    invoices.map do |invoice|
      customers.find do |customer|
        if customer.id == invoice.customer_id
          hash[customer] = customer.id
        end
      end
    end
    hash.keys
  end

end
