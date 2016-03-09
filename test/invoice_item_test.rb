require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/invoice_item'
require 'simplecov'
SimpleCov.start

class InvoiceItemTest < Minitest::Test
  attr_reader :ii
  def setup
    @ii = InvoiceItem.new({
  :id => 6,
  :item_id => 7,
  :invoice_id => 8,
  :quantity => 1,
  :unit_price => BigDecimal.new(10.99, 4),
  :created_at => Time.now,
  :updated_at => Time.now
})
  end

  def test_that_ii_item_class_exists
    assert_equal InvoiceItem, ii.class
  end

  def test_that_ii_has_a_id
    assert_equal 6, ii.id
  end

  def test_that_ii_has_a_item_id
    assert_equal 7, ii.item_id
  end

  def test_that_ii_has_a_invoice_id
    assert_equal 8, ii.invoice_id
  end

  def test_that_ii_has_a_quantity
    assert_equal 1, ii.quantity
  end

  def test_that_ii_has_a_creation_date
    assert_equal Time, ii.created_at.class
  end

  def test_that_ii_has_a_updated_date
    assert_equal Time, ii.updated_at.class
  end

end
