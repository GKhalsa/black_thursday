require "minitest/autorun"
require "minitest/pride"
require_relative "../lib/invoice_item_repository"
require_relative "../lib/sales_engine"
require 'simplecov'
SimpleCov.start

class InvoiceItemRepositoryTest < Minitest::Test
  attr_reader :inv_item_repo

  def setup
    @se ||= SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    @inv_item_repo = @se.invoice_items
  end

  def test_can_find_all_instances_of_invoice_item
    invoice_items  = inv_item_repo.all
    assert_equal 21830, invoice_items.count
  end

  def test_can_find_invoice_items_by_id
    invoice_item  = inv_item_repo.find_by_id(7)
    assert_equal 263563764, invoice_item.item_id
    assert_equal nil, inv_item_repo.find_by_id(99999999)
  end

  def test_can_find_all_invoice_items_by_item_id
    invoice_items = inv_item_repo.find_all_by_item_id(263526970)
    assert_equal 25, invoice_items.count
    assert_equal 0, inv_item_repo.find_all_by_item_id(99999999).count

  end

  def test_can_find_all_invoice_items_by_invoice_id
    invoice_items = inv_item_repo.find_all_by_invoice_id(10)
    assert_equal 5, invoice_items.count
    assert_equal 0, inv_item_repo.find_all_by_invoice_id(-1).count
  end
end
