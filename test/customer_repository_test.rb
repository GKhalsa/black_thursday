require "minitest/autorun"
require "minitest/pride"
require_relative "../lib/customer_repository"
require_relative "../lib/sales_engine"
require 'simplecov'
SimpleCov.start

class InvoiceItemRepositoryTest < Minitest::Test

  def setup
    @se ||= SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions => "./data/transactions.csv",
      :customers => "./data/customers.csv"
      })
  end

  def test_can_find_all_instances_of_customer
    customer_repo = @se.customers
    customers  = customer_repo.all
    assert_equal 1000, customers.count
  end

  def test_can_find_customer_by_id
    customer_repo = @se.customers
    customer = customer_repo.find_by_id(32)
    assert_equal "Pasquale", customer.first_name
  end

  def test_can_find_all_by_first_name
    customer_repo = @se.customers
    customer = customer_repo.find_all_by_first_name("Pas")
    assert_equal 1, customer.count
    customers = customer_repo.find_all_by_first_name("Pa")
    assert_equal 11, customers.count
  end


  def test_can_find_all_by_last_name
    customer_repo = @se.customers
    customer = customer_repo.find_all_by_last_name("Pa")
    assert_equal 8, customer.count
  end
end
