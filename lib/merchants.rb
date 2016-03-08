require 'pry'
class Merchant
  attr_accessor :name, :id, :merchant_repo, :merchant_total_revenue

  def initialize(hash, merchant_repo = nil)
    @name          = hash[:name]
    @id            = hash[:id]
    @merchant_repo = merchant_repo
    @merchant_total_revenue = 0
  end

  def items
    merchant_repo.items_from_item_repo(id)
  end

  def invoices
    merchant_repo.invoices_from_invoice_repo(id)
  end

  def are_invoices_pending?
    invoices.any? do |invoice|
      invoice.is_pending?
    end
  end

  def customers
    invoices.map {|invoice| invoice.customer}.uniq
  end

  def total_revenue
    revenue = invoices.reduce(0) do |sum, invoice|
      sum += invoice.total
    #maybe create a module that adds up invoices, called in lots of places
    end
    @merchant_total_revenue += revenue
  end

end
