require 'pry'

class SalesAnalyst
  attr_reader :sales_engine, :items_per_merchant

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def average_items_per_merchant
    @items_per_merchant = []
    sales_engine.merchant_repo.merchants.each do |merchant|
      items_per_merchant << merchant.items.count
    end
    (items_per_merchant.reduce(:+)/items_per_merchant.count.to_f).round(2)
  end

  def average_items_per_merchant_standard_deviation
    mean = average_items_per_merchant
    num_of_items_squared = []
    items_per_merchant.each do |num_of_items|
      num_of_items_squared << (num_of_items - mean) ** 2
    end
    x = (num_of_items_squared.reduce(:+)/(items_per_merchant.count - 1.to_f))
    Math.sqrt(x).round(2)
  end

  def merchants_with_high_item_count
    high_item_count = average_items_per_merchant + average_items_per_merchant_standard_deviation

    sales_engine.merchant_repo.merchants.find_all do |merchant|
      merchant.items.count > high_item_count
    end
  end

  def average_item_price_per_merchant(merchant_id)
    #find the merchant by the id and then find the number of goods the merchant has and find the average price of goods
    merchant = sales_engine.merchant_repo.find_by_id(merchant_id)
    merchant_items = merchant.items
    prices = []
    merchant_items.each do |merchant_item|
      prices << merchant_item.unit_price.to_f
    end
    (prices.reduce(:+)/prices.count).round(2)
  end


end