require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require 'pry'
class SalesEngineTest < Minitest::Test
  def setup
    @se ||= SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv"
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
meta single:true
  def test_relationship_layer_between_invoices_and_merchants
    merchant = @se.merchants.find_by_id(12334105)
    merchant.invoices
    assert_equal 10, merchant.invoices.count
    invoice = @se.invoices.find_by_id(1)
    assert_equal "IanLudiBoards", invoice.merchant[0].name
  end
end
