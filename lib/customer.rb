class Customer

  attr_reader :id, :first_name, :last_name, :created_at,
              :updated_at, :customer_repo

  def initialize(customer_data, customer_repo = nil)
    @id            = customer_data[:id]
    @first_name    = customer_data[:first_name]
    @last_name     = customer_data[:last_name]
    @created_at    = customer_data[:created_at]
    @updated_at    = customer_data[:updated_at]
    @customer_repo = customer_repo
  end

  def invoices
    customer_repo.invoices_from_invoice_repo(id)
  end

  def merchants
    invoices.map { |invoice| invoice.merchant }
  end

  def broke_sabbath?
    invoices.any? do |invoice|
      invoice.created_at.strftime("%A") == "Saturday"
    end
  end

end
