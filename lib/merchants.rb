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

  def invoice_items
    binding.pry
    invoices.map(&:invoice_items).compact
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

  def most_sold_item_num
    invoice_items.flatten.max_by do |invoice_item|
      invoice_item.quantity
    end.quantity
  end

  def most_sold_item
    binding.pry
    x = invoice_items.flatten.find_all do |invoice_item|
      invoice_item.quantity == most_sold_item_num
    end
    x.map(&:find_item)
  end

  def give_invoice_items_their_total
    invoice_items.flatten.each do |invoice_item|
      invoice_item.find_total
    end
  end

  def best_item_sales
    give_invoice_items_their_total
    x = invoice_items.flatten.max_by do |invoice_item|
      invoice_item.total
    end.find_item
  end

  def customers
    invoices.map {|invoice| invoice.customer}.uniq
  end

  def total_revenue
    # invoices.delete_if == invoices.is_pending?
    revenue = invoices.reduce(0) do |sum, invoice|
      sum += invoice.total
    #maybe create a module that adds up invoices, called in lots of places
    end
    @merchant_total_revenue += revenue
  end

  def merchant_total_revenue
    total_revenue
    @merchant_total_revenue
  end

end
