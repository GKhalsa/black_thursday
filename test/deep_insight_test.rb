require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require 'time'
require_relative '../lib/deep_insight_connections'
require 'simplecov'
SimpleCov.start

class DeepInsightTest < Minitest::Test
  attr_reader :se, :di

  def setup
    @se ||= SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
      @di ||= DeepInsight.new(se)
  end

  def test_find_all_the_jewish_names
    assert_equal 92, di.jewish_customer_object_array.count
  end

  def test_find_who_broke_the_sabbath
    assert_equal 47, di.who_broke_the_sabbath?.count
  end

end
