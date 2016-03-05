require "minitest/autorun"
require "minitest/pride"
require_relative "../lib/invoice_item_repository"
require_relative "../lib/sales_engine"

class InvoiceItemRepositoryTest < Minitest::Test

  def setup
    @se ||= SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv"
      })
  end

  def test_can_find_all_instances_of_invoice_item
    inv_item_repo = @se.invoice_items
    invoice_items  = inv_item_repo.all
    assert_equal 21830, invoice_items.count
  end

  def test_can_find_invoice_items_by_id
    inv_item_repo = @se.invoice_items
    invoice_item  = inv_item_repo.find_by_id(7)
    assert_equal 263563764, invoice_item.item_id
  end

  def test_can_find_all_invoice_items_by_item_id
    inv_item_repo = @se.invoice_items
    invoice_items = inv_item_repo.find_all_by_item_id(263526970)
    assert_equal 25, invoice_items.count
  end

  meta blah:true
  def test_can_find_all_invoice_items_by_invoice_id
    inv_item_repo = @se.invoice_items
    invoice_items = inv_item_repo.find_all_by_invoice_id(10)
    assert_equal 5, invoice_items.count
  end 
end
