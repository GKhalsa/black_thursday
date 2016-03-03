require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require 'pry'
class SalesEngineTest < Minitest::Test
  def setup
    @se ||= SalesEngine.from_csv({
      :items => "../data/items.csv",
      :merchants => "../data/merchants.csv"
      })
  end

  def test_loading_in_the_csv
    assert @se.merchants
  end

  def test_starting_relationship_layer
    merchant = @se.merchants.find_by_id(12334105)
    merchant.items
    # => [<item>, <item>, <item>]
    item = @se.items.find_by_id(20)
    item.merchant
    # => <merchant>
  end

end
