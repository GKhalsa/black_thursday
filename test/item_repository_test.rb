require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/item_repository'
require_relative '../lib/sales_engine'
require 'simplecov'
SimpleCov.start

class ItemRepositoryTest < Minitest::Test
  attr_reader :ir

  def setup
    @se ||= SalesEngine.from_csv({
        :items         => "./data/items.csv",
        :merchants     => "./data/merchants.csv",
        :invoices      => "./data/invoices.csv",
        :invoice_items => "./data/invoice_items.csv",
        :transactions  => "./data/transactions.csv",
        :customers     => "./data/customers.csv"
                                })
    @ir = @se.items
  end

  def test_can_find_all_instances_of_item
    item = ir.all
    assert_equal 1367, item.count
  end

  def test_can_find_item_by_id
    item = ir.find_by_id(263395237)
    assert_equal "510+ RealPush Icon Set", item.name
  end

  def test_can_find_item_by_name
    item = ir.find_by_name("510+ RealPush Icon Set")
    assert_equal 263395237, item.id
  end

  def test_can_find_all_items_with_description
    item = ir.find_all_with_description("boNuS")
    assert_equal "510+ RealPush Icon Set", item[0].name
  end

  def test_can_find_all_items_by_price
    item = ir.find_all_by_price(600.00)
    assert_equal 6, item.count
    assert_equal "Introspection virginalle", item[0].name
  end

  def test_can_find_all_items_by_price_in_range
    price_range = (599..600)
    price_range2 = (598..599).to_a
    price_range3 = (600..600).to_a
    item = ir.find_all_by_price_in_range(price_range)
    item2 = ir.find_all_by_price_in_range(price_range2)
    item3 = ir.find_all_by_price_in_range(price_range3)
    assert_equal 6, item.count
    assert_equal 0, item2.count
    assert_equal 6, item3.count
  end

  def test_can_find_all_items_by_merchant_id
    item = ir.find_all_by_merchant_id(12334213)
    assert_equal "Eule - Topflappen, handgehäkelt, Paar", item[0].name
    assert_equal 263396279, item[0].id
  end

end
