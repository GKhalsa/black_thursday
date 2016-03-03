require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/merchants'

class MerchantsTest < Minitest::Test

  def test_that_merchants_exists
    merchant = Merchant.new({:name => "Ilana", id: "1"})
    assert_equal Merchant, merchant.class
  end

  def test_we_can_call_each_merchant_instance_by_name
    merchant = Merchant.new({:name => "Ilana", id: "1"})
    assert_equal "Ilana", merchant.name
  end

  def test_we_can_call_each_merchant_instance_by_id
    merchant = Merchant.new({:name => "Ilana", id: "1"})
    assert_equal "1", merchant.id
  end

end
