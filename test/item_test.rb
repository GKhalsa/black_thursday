require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/item'

class ItemTest < Minitest::Test

  def test_that_item_exists
    item = Item.new({:name => "Ilana", description: "lol", unit_price: "1200", created_at: "07/12/83", updated_at: "1995-03-19 10:02:43 UTC" })
    assert_equal Item, item.class
  end

  def test_that_item_has_a_name
    item = Item.new({:name => "Ilana", description: "lol", unit_price: "1200", created_at: "07/12/83", updated_at: "1995-03-19 10:02:43 UTC" })
    assert_equal "Ilana", item.name
  end

  def test_that_item_has_a_description
    item = Item.new({:name => "Ilana", description: "lol", unit_price: "1200", created_at: "07/12/83", updated_at: "1995-03-19 10:02:43 UTC" })
    assert_equal "lol", item.description
  end

  def test_that_item_has_a_unit_price
    item = Item.new({:name => "Ilana", description: "lol", unit_price: "1200", created_at: "07/12/83", updated_at: "1995-03-19 10:02:43 UTC" })
    assert_equal "1200", item.unit_price
  end

  def test_that_item_has_a_creation_date
    item = Item.new({:name => "Ilana", description: "lol", unit_price: "1200", created_at: "07/12/83", updated_at: "1995-03-19 10:02:43 UTC" })
    assert_equal "07/12/83", item.created_at
  end

  def test_that_item_has_a_updated_date
    item = Item.new({:name => "Ilana", description: "lol", unit_price: "1200", created_at: "07/12/83", updated_at: "1995-03-19 10:02:43 UTC" })
    assert_equal "1995-03-19 10:02:43 UTC", item.updated_at
  end

end
