require 'pry'
class Merchant
  attr_accessor :name, :id, :merchant_repo,
                :merchant_total_revenue, :created_at

  def initialize(hash, merchant_repo = nil)
    @name                   = hash[:name]
    @id                     = hash[:id]
    @created_at             = hash[:created_at]
    @merchant_repo          = merchant_repo
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

  def creation_date_items(month)
    if created_at.strftime("%B") == month
      items.count
    end
  end

  def most_sold_item
    x = invoices.map do |invoice|
      invoice.invoice_items
    end
    y = x.flatten.max_by do |invoice_item|
      invoice_item.quantity
    end.quantity
    z = x.flatten.find_all do |invoice_item|
      invoice_item.quantity == y
    end

    binding.pry
    #refactor!!
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
