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
end
