class Merchant
  attr_accessor :name, :id, :merchant_repo

  def initialize(hash, merchant_repo = nil)
    @name          = hash[:name]
    @id            = hash[:id]
    @merchant_repo = merchant_repo
  end

  def items
    merchant_repo.items_from_item_repo(id)
  end

  def invoices
    merchant_repo.invoices_from_invoice_repo(id)
  end

  def customers
    invoices.map {|invoice| invoice.customer}.uniq
  end

end
