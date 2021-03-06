require 'pry'
class Item

  attr_reader :id, :name, :description, :unit_price,
              :created_at, :updated_at, :merchant_id,
              :item_repo

  def initialize(item_data, item_repo = nil)
    @id          = item_data[:id]
    @name        = item_data[:name]
    @description = item_data[:description]
    @unit_price  = item_data[:unit_price]
    @created_at  = item_data[:created_at]
    @updated_at  = item_data[:updated_at]
    @merchant_id = item_data[:merchant_id]
    @item_repo   = item_repo
  end

  def unit_price_by_dollars
    unit_price.to_f
  end

  def merchant
    item_repo.searching_for_merchants(merchant_id)
  end

end
