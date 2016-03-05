require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require 'pry'

class SalesEngineTest < Minitest::Test
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

  def test_relationship_layer_between_invoice_and_items
    invoice = @se.invoices.find_by_id(20)
    assert_equal 12336163, invoice.merchant_id
    items = invoice.items
    assert_equal 5, items.count
    transactions = invoice.transactions
    assert_equal 3, transactions.count
    customer = invoice.customer
    assert_equal "Sylvester", customer.first_name
  end
end
