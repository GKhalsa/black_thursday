require "csv"
require_relative "item"
require 'pry'
require 'bigdecimal'
require 'time'
require_relative "transaction"

class TransactionRepository
  attr_reader :transaction_array, :sales_engine

  def initialize(sales_engine)
    @transaction_array = []
    @sales_engine ||= sales_engine
  end

  def invoices_from_invoice_repo
    sales_engine.invoices.invoice_array
  end

  def inspect
    "#<#{self.class} #{@transaction_array.size} rows>"
  end

  def all
    transaction_array
  end

  def find_by_id(id)
    transaction_array.find do |transaction|
      transaction.id == id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    transaction_array.find_all do |transaction|
      transaction.invoice_id == invoice_id
    end
  end

  def find_all_by_credit_card_number(credit_card_number)
    transaction_array.find_all do |transaction|
      transaction.credit_card_number == credit_card_number
    end
  end

  def find_all_by_result(result)
    transaction_array.find_all do |transaction|
      transaction.result == result
    end
  end

  def load_csv(transactions_file)
    contents = CSV.open "#{transactions_file}", headers: true, header_converters: :symbol
    contents.each do |row|
      id = row[:id].to_i
      invoice_id = row[:invoice_id].to_i
      credit_card_number = row[:credit_card_number].to_i
      credit_card_expiration_date = row[:credit_card_expiration_date]
      result = row[:result]
      created_at = Time.parse(row[:created_at])
      updated_at = Time.parse(row[:updated_at])
      @transaction_array << Transaction.new({:id => id,
      :invoice_id => invoice_id, :credit_card_number => credit_card_number,
      :credit_card_expiration_date => credit_card_expiration_date,
      :result => result, :created_at => created_at, :updated_at => updated_at}, self)
    end
  end
end
