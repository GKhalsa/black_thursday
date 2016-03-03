require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/invoice'

class InvoiceTest < Minitest::Test
  attr_reader :invoice
  def setup
    @invoice = Invoice.new({id: 6, customer_id: 7, merchant_id: 8, status: "pending", created_at: Time.now, updated_at: Time.now})
  end

  def test_that_invoice_exists
    assert_equal Invoice, invoice.class
  end

  def test_that_invoice_has_a_id
    assert_equal 6, invoice.id
  end

  def test_that_invoice_has_a_customer_id
    assert_equal 7, invoice.customer_id
  end

  def test_that_invoice_has_a_merchant_id
    assert_equal 8, invoice.merchant_id
  end

  def test_that_invoice_has_a_status
    assert_equal "pending", invoice.status
  end

  def test_that_invoice_has_a_creation_date
    assert_equal Time, invoice.created_at.class
  end

  def test_that_invoice_has_a_updated_date
    assert_equal Time, invoice.updated_at.class
  end

end
