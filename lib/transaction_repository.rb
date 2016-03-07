require "csv"
require_relative "item"
require 'pry'
require 'bigdecimal'
require 'time'
require_relative "transaction"
require_relative "loader"

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
    if transaction_array.empty?
      contents = FileLoader.load_csv(transactions_file)
      csv_contents_loader(contents)
    end
  end

  def instance_loader(data)
    @transaction_array << Transaction.new({
      id: data[0], invoice_id: data[1],
      credit_card_number: data[2],
      credit_card_expiration_date: data[3],
      result: data[4], created_at: data[5],
      updated_at: data[6]}, self)
  end

  def csv_contents_loader(contents)
    contents.each do |row|
      data = []
      data << row[:id].to_i
      data << row[:invoice_id].to_i
      data << row[:credit_card_number].to_i
      data << row[:credit_card_expiration_date]
      data << row[:result]
      data << Time.parse(row[:created_at])
      data << Time.parse(row[:updated_at])
      instance_loader(data)
    end
  end
end
