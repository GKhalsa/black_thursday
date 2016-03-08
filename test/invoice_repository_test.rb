require "minitest/autorun"
require "minitest/pride"
require_relative "../lib/invoice_repository"
require_relative "../lib/sales_engine"
require 'time'

class InvoiceRepositoryTest < Minitest::Test

  def setup
    @se ||= SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions => "./data/transactions.csv",
      :customers => "./data/customers.csv"
      })
  end
  def test_can_find_all_instances_of_invoice
    inv_repo = @se.invoices
    invoice = inv_repo.all
    assert_equal 4985, invoice.count
  end

  def test_can_find_invoices_by_id
    inv_repo = @se.invoices
    invoice = inv_repo.find_by_id(7)
    assert_equal 12335009, invoice.merchant_id
  end

  def test_can_find_all_invoices_by_customer_id
    inv_repo = @se.invoices
    invoice = inv_repo.find_all_by_customer_id(5)
    assert_equal 12336113, invoice[0].merchant_id
    assert_equal 16, invoice[0].id
  end

  def test_can_find_all_invoices_by_merchant_id
    inv_repo = @se.invoices
    invoice = inv_repo.find_all_by_merchant_id(12335009)
    assert_equal 7, invoice[0].id
  end

  def test_can_find_all_by_status
    inv_repo = @se.invoices
    invoice = inv_repo.find_all_by_status(:pending)
    assert_equal 1473, invoice.count
  end

  def test_can_find_all_by_created_at
    date = Time.parse("2009-02-07")
    inv_repo = @se.invoices
    invoices = inv_repo.find_all_by_created_at(date)
    assert_equal 1, invoices.count
  end

end
