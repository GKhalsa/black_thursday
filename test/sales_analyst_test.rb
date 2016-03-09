require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_analyst'
require_relative '../lib/sales_engine'
require 'time'


class SalesAnalystTest < Minitest::Test
  attr_reader :se, :sa

  def setup
    @se ||= SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    @sa ||= SalesAnalyst.new(se)
  end

  def test_sales_analyst_class_exists
    assert_equal SalesAnalyst, sa.class
  end

  def test_sales_analyst_is_initialzed_with_an_instance_of_sales_engine
    assert_equal SalesEngine, sa.sales_engine.class
  end
  def test_average_items_per_merchant
    assert_equal 2.88, sa.average_items_per_merchant
  end

  def test_average_items_per_merchant_standard_deviation
    assert_equal 3.26, sa.average_items_per_merchant_standard_deviation
  end

  def test_merchants_with_high_item_count
    merchants_with_high_item_count = sa.merchants_with_high_item_count
    assert_equal 52, merchants_with_high_item_count.count
  end

  def test_average_item_price_per_merchant
    assert_equal 16.66, sa.average_item_price_for_merchant(12334105)
  end

  def test_average_average_price_across_all_merchants
    assert_equal 350.29, sa.average_average_price_per_merchant
  end

  def test_golden_items
    assert_equal 5, sa.golden_items.count
  end

  def test_average_invoices_per_merchant
    assert_equal 10.49, sa.average_invoices_per_merchant
  end

  meta refactor:true
  def test_average_invoices_per_merchant_standard_deviation
    assert_equal 3.29, sa.average_invoices_per_merchant_standard_deviation
  end

  def test_awesome_deviation
    mean = 4
    merch_avg_items = [1,3,6,8,2]
    expected = 2.92
    result = sa.awesome_deviation_maker(mean, merch_avg_items)
    assert_equal expected, result
  end

  def test_top_merchants_by_invoice_count
    assert_equal 12, sa.top_merchants_by_invoice_count.count
  end

  def test_bottom_merchants_by_invoice_count
    assert_equal 4, sa.bottom_merchants_by_invoice_count.count
  end

  def test_top_days_by_invoice_count
    assert_equal 1, sa.top_days_by_invoice_count.count
    assert_equal "Wednesday", sa.top_days_by_invoice_count[0]
  end

  def test_status_of_invoices
    assert_equal 29.55, sa.invoice_status(:pending)
    assert_equal 56.95, sa.invoice_status(:shipped)
    assert_equal 13.5, sa.invoice_status(:returned)
  end

  def test_total_revenue_by_date
    date = Time.parse("2009-02-07")
    assert_equal 6838064.02, sa.total_revenue_by_date(date).to_f
  end
  def test_top_x_performing_merchants_by_revenue
    assert_equal 10, sa.top_revenue_earners(10).count
    assert_equal 12335938, sa.top_revenue_earners(10)[0].id
  end

  def test_top_20_performing_merchants_by_revenue_by_default
    assert_equal 20, sa.top_revenue_earners.count
    assert_equal 20829891.45, sa.top_revenue_earners[0].merchant_total_revenue.to_f
  end

  def test_merchants_with_pending_invoices
    assert_equal 467, sa.merchants_with_pending_invoices.count
  end

  def test_merchants_with_only_one_item
    assert_equal 243, sa.merchants_with_only_one_item.count
  end

  def test_merchants_with_only_one_item_registered_in_month
    assert_equal 21, sa.merchants_with_only_one_item_registered_in_month("March").count
  end

  def test_total_revenue_for_single_merchant
    assert_equal 81572.4, sa.revenue_by_merchant(12334194).to_f
  end

  meta big:true
  def test_best_selling_item_by_merchant
    assert_equal 1, sa.most_sold_item_for_merchant(12334189).count
    assert_equal 263524984, sa.most_sold_item_for_merchant(12334189)[0].id
  end

  def test_best_item_for_merchant
    assert_equal 263516130, sa.best_item_for_merchant(12334189).id
  end


end
