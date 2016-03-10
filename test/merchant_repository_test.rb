require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/merchant_repository'
require_relative '../lib/sales_engine'
require 'simplecov'
SimpleCov.start


class MerchantRepositoryTest < Minitest::Test
  attr_reader :mr

  def setup
    @se ||= SalesEngine.from_csv({
        :items         => "./data/items.csv",
        :merchants     => "./data/merchants.csv",
        :invoices      => "./data/invoices.csv",
        :invoice_items => "./data/invoice_items.csv",
        :transactions  => "./data/transactions.csv",
        :customers     => "./data/customers.csv"
                    })
    @mr = @se.merchants
  end

  def test_can_it_find_a_merchant_by_name
    merchant = mr.find_by_name("CJsDecor")
    assert_equal merchant, mr.find_by_name("CJsDecor")
  end

  def test_merchant_repo_can_find_all_instances
    merchant = mr.all
    assert_equal merchant[0], mr.find_by_name("Shopin1901")
    assert_equal merchant[2], mr.find_by_name("MiniatureBikez")
    assert_equal merchant[4], mr.find_by_name("Keckenbauer")
    assert_equal merchant[6], mr.find_by_name("GoldenRayPress")
  end

  def test_merchant_repo_can_find_by_id
    merchant = mr.find_by_id("12334105")
    assert_equal merchant, mr.find_by_id("12334105")
  end

  def test_merchant_repo_can_find_by_name_fragment
    name_1 = "OneLovePhotographyIN"
    name_2 = "ForTheLoveOfCop"
    name_3 = "DivineLoveSigrun"
    assert_equal 3, mr.find_all_by_name("elO").count
    assert_equal name_1, mr.find_all_by_name("Elo")[0].name
    assert_equal name_2, mr.find_all_by_name("eLo")[1].name
    assert_equal name_3, mr.find_all_by_name("ELO")[2].name
  end

  def test_for_no_name_matching
    assert_equal 0, mr.find_all_by_name("el999").count
  end
end
