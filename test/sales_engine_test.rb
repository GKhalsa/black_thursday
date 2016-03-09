require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require 'pry'
require 'simplecov'
SimpleCov.start

class SalesEngineTest < Minitest::Test
  def setup
    @se ||= SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./fixtures/invoice_items_fixture.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
  end

  def test_loading_in_the_csv
    assert @se.merchants
  end

  def test_starting_relationship_layer
    merchant = @se.merchants.find_by_id(12334105)
    merchant.items
    assert_equal 3, merchant.items.count

    item = @se.items.find_by_id(263395617)
    item.merchant
    assert_equal "Madewithgitterxx", item.merchant.name
  end

  def test_relationship_layer_between_invoices_and_merchants
    merchant = @se.merchants.find_by_id(12334105)
    merchant.invoices
    assert_equal 10, merchant.invoices.count

    invoice = @se.invoices.find_by_id(1)
    assert_equal "IanLudiBoards", invoice.merchant.name
  end

  def test_relationship_layer_between_invoice_and_items_transactions_customers
    invoice = @se.invoices.find_by_id(20)
    assert_equal 12336163, invoice.merchant_id
    items = invoice.items
    assert_equal 5, items.count
    transactions = invoice.transactions
    assert_equal 3, transactions.count
    customer = invoice.customer
    assert_equal "Sylvester", customer.first_name
  end

  def test_relationship_layer_between_transactions_and_invoices
    transaction = @se.transactions.find_by_id(40)
    invoice = transaction.invoice
    assert_equal 12335150, invoice.merchant_id
  end

  def test_relationship_layer_between_merchants_and_customers
    merchant = @se.merchants.find_by_id(12334194)
    customers = merchant.customers
    assert_equal 12, customers.count
  end

  def test_relationship_layer_between_customers_and_merchants
    customer = @se.customers.find_by_id(30)
    merchants = customer.merchants
    assert_equal 5, merchants.count
  end

  def test_that_invoices_are_paid_in_full
    invoice = @se.invoices.find_by_id(10)
    assert_equal true, invoice.is_paid_in_full?
  end

  def test_that_invoices_can_total
    invoice = @se.invoices.find_by_id(1)
    assert_equal 21067.77, invoice.total
  end
end
