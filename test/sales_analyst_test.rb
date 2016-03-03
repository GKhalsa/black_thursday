require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_analyst'
require_relative '../lib/sales_engine'


class SalesAnalystTest < Minitest::Test
  def setup
    @se ||= SalesEngine.from_csv({
      :items => "../data/items.csv",
      :merchants => "../data/merchants.csv"
      })
  end

  def test_sales_analyst_class_exists
    sa = SalesAnalyst.new(@se)
    assert_equal SalesAnalyst, sa.class
  end

  def test_sales_analyst_is_initialzed_with_an_instance_of_sales_engine
    sa = SalesAnalyst.new(@se)
    assert_equal SalesEngine, sa.sales_engine.class
  end

  def test_average_items_per_merchant
    sa = SalesAnalyst.new(@se)

    assert_equal 2.88, sa.average_items_per_merchant
  end

  def test_average_items_per_merchant_standard_deviation
    sa = SalesAnalyst.new(@se)
      assert_equal 3.26, sa.average_items_per_merchant_standard_deviation
  end

  def test_merchants_with_high_item_count
    sa = SalesAnalyst.new(@se)
    merchants_with_high_item_count = sa.merchants_with_high_item_count
      assert_equal 52, merchants_with_high_item_count.count
  end

  def test_average_item_price_per_merchant
    sa = SalesAnalyst.new(@se)
      assert_equal 15.67, sa.average_item_price_per_merchant(12334105)
  end

  def test_average_average_price_across_all_merchants
    sa = SalesAnalyst.new(@se)
    assert_equal 350.16, sa.average_average_price_per_merchant
  end

  def test_golden_items
    sa = SalesAnalyst.new(@se)
    assert_equal 114, sa.golden_items.count
  end
end
