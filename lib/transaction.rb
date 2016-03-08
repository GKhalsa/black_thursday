require 'pry'

class Transaction

  attr_reader :id, :invoice_id, :credit_card_number,
              :credit_card_expiration_date,
              :result, :created_at, :updated_at,
              :transaction_repo

  def initialize(transaction_data, transaction_repo = nil)
    @id = transaction_data[:id]
    @invoice_id = transaction_data[:invoice_id]
    @credit_card_number = transaction_data[:credit_card_number]
    @credit_card_expiration_date = transaction_data[:credit_card_expiration_date]
    @result = transaction_data[:result]
    @created_at = transaction_data[:created_at]
    @updated_at = transaction_data[:updated_at]
    @transaction_repo = transaction_repo
  end

  def invoice
    transaction_repo.invoices_from_invoice_repo(invoice_id)
  end

end
