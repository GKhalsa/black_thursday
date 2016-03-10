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
  def test_that_we_can_identify_a_female
    assert_equal :female, di.determine_gender("Sally")
  end

  def test_that_we_can_identify_a_male
    assert_equal :male, di.determine_gender("Bob")
  end

  def test_gender_hash
    di.mapping_customer_to_gender
    assert_equal "Joey",di.gender_hash.key(:male).first_name
  end

  def test_most_popular_day_for_man
    di.popular_days
    assert_equal "Friday", di.male_pop_day
    assert_equal "Sunday", di.female_pop_day
  end

end
