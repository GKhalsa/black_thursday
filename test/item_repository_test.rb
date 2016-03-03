require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/item_repository'
require_relative '../lib/sales_engine'

class ItemRepositoryTest < Minitest::Test
  def setup
    @se ||= SalesEngine.from_csv({
                  :items     => "../data/items.csv",
                  :merchants => "../data/merchants.csv",
                              })
  end

  def test_can_find_all_instances_of_item
    ir = @se.items
    item = ir.all
    assert_equal 1367, item.count
  end

  def test_can_find_item_by_id
    ir = @se.items
    item = ir.find_by_id(263395237)
    assert_equal "510+ RealPush Icon Set", item.name
  end

  def test_can_find_item_by_name
    ir = @se.items
    item = ir.find_by_name("510+ RealPush Icon Set")
    assert_equal 263395237, item.id
  end

  def test_can_find_all_items_with_description
    ir = @se.items
    item = ir.find_all_with_description("boNuS")
    assert_equal "510+ RealPush Icon Set", item[0].name
  end

  def test_can_find_all_items_by_price
    ir = @se.items
    item = ir.find_all_by_price(600.00)
    assert_equal 6, item.count
    assert_equal "Introspection virginalle", item[0].name
  end

  def test_can_find_all_items_by_price_in_range
    skip
    ir = @se.items
    price_range = (59999..60001).to_a
    # price_range2 = (59888..59999).to_a
    # price_range3 = (60001..60009).to_a
    item = ir.find_all_by_price_in_range(price_range)
    # item2 = ir.find_all_by_price_in_range(price_range2)
    # item3 = ir.find_all_by_price_in_range(price_range3)
    assert_equal 6, item.count
    # assert_equal 0, item2.count
    # assert_equal 0, item3.count
  end

  def test_can_find_all_items_by_merchant_id
    ir = @se.items
    item = ir.find_all_by_merchant_id(12334213)
    assert_equal "Eule - Topflappen, handgehäkelt, Paar", item[0].name
    assert_equal 263396279, item[0].id
  end
  #test for edge cases nil as argument, non matching arguments

end
