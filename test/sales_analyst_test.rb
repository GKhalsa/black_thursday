require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_analyst'
require_relative '../lib/sales_engine'


class SalesAnalystTest < Minitest::Test
  def setup
    @se ||= SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv"
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
      assert_equal 16.66, sa.average_item_price_for_merchant(12334105)
  end

  def test_average_average_price_across_all_merchants
    sa = SalesAnalyst.new(@se)
    assert_equal 350.29, sa.average_average_price_per_merchant
  end

  def test_golden_items
    sa = SalesAnalyst.new(@se)
    assert_equal 5, sa.golden_items.count
  end

  def test_average_invoices_per_merchant
    sa = SalesAnalyst.new(@se)
    assert_equal 10.49, sa.average_invoices_per_merchant
  end

  def test_average_invoices_per_merchant_standard_deviation
    sa = SalesAnalyst.new(@se)
    assert_equal 3.29, sa.average_invoices_per_merchant_standard_deviation
  end

  def test_awesome_deviation
    sa = SalesAnalyst.new(@se)
    mean = 4
    merch_avg_items = [1,3,6,8,2]
    expected = 2.92
    result = sa.awesome_deviation_maker(mean, merch_avg_items)
    assert_equal expected, result
  end

  def test_top_merchants_by_invoice_count
    sa = SalesAnalyst.new(@se)
    assert_equal 12, sa.top_merchants_by_invoice_count.count
  end

  def test_bottom_merchants_by_invoice_count
    sa = SalesAnalyst.new(@se)
    assert_equal 4, sa.bottom_merchants_by_invoice_count.count
  end

  def test_top_days_by_invoice_count
    sa = SalesAnalyst.new(@se)
    assert_equal 1, sa.top_days_by_invoice_count.count
    assert_equal "Wednesday", sa.top_days_by_invoice_count[0]
  end

  def test_status_of_invoices
    sa = SalesAnalyst.new(@se)
    assert_equal 29.55, sa.invoice_status(:pending)
    assert_equal 56.95, sa.invoice_status(:shipped)
    assert_equal 13.5, sa.invoice_status(:returned)
  end


end
