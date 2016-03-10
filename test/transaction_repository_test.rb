require "minitest/autorun"
require "minitest/pride"
require_relative "../lib/transaction_repository"
require_relative "../lib/sales_engine"
require 'simplecov'
SimpleCov.start

class TransactionRepositoryTest < Minitest::Test
  attr_reader :transaction_repo

  def setup
    @se ||= SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions => "./data/transactions.csv",
      :customers => "./data/customers.csv"
      })
    @transaction_repo = @se.transactions
  end

  def test_can_find_all_instances_of_transaction
    transactions  = transaction_repo.all
    assert_equal 4985, transactions.count
  end

  def test_can_find_transactions_by_id
    transactions  = transaction_repo.find_by_id(14)
    assert_equal 3560, transactions.invoice_id
  end

  def test_can_find_all_transactions_by_invoice_id
    transactions = transaction_repo.find_all_by_invoice_id(10)
    assert_equal 3, transactions.count
  end

  def test_can_find_all_transactions_by_credit_card_number
    transactions = transaction_repo.find_all_by_credit_card_number(4518913442963142)
    assert_equal 1, transactions.count
  end

  def test_can_find_all_transactions_by_result
    transactions  = transaction_repo.find_all_by_result("success")
    assert_equal 4158, transactions.count
  end
end
