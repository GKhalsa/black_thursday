require 'pry'

class SalesAnalyst
  attr_reader :sales_engine, :items_per_merchant, :average_average_prices

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def average_items_per_merchant
    @items_per_merchant = []
    sales_engine.merchants.merchant_array.each do |merchant|
      items_per_merchant << merchant.items.count
    end
    (items_per_merchant.reduce(:+)/items_per_merchant.count.to_f).round(2)
  end


  def merchants_with_high_item_count
    high_item_count = average_items_per_merchant + average_items_per_merchant_standard_deviation

    sales_engine.merchants.merchant_array.find_all do |merchant|
      merchant.items.count > high_item_count
    end
  end

  def average_item_price_for_merchant(merchant_id)
    merchant = sales_engine.merchants.find_by_id(merchant_id)
    merchant_items = merchant.items
    prices = []
    merchant_items.each do |merchant_item|
      prices << merchant_item.unit_price
    end
    (prices.reduce(:+)/prices.count).round(2)
  end

  def average_average_price_per_merchant
    @average_average_prices= []
    sales_engine.merchants.merchant_array.each do |merchant|
      merch_id = merchant.id
      average_average_prices << average_item_price_for_merchant(merch_id)
    end
    (average_average_prices.reduce(:+)/average_average_prices.count).round(2)
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

  # def awesome_deviation_maker(mean, merch_avg_items)
  #   x = (merch_avg_items.reduce(0) do |acc, avg_num|
  #     acc + ((avg_num - mean) ** 2)
  #   end)/(merch_avg_items.count - 1)
  #   Math.sqrt(x).round(2)
  # end



  def average_item_price_standard_deviation
    mean = average_average_price_per_merchant
    prices = []
    prices_minused_and_squared = []
    sales_engine.items.item_array.group_by do |item|
      prices << item.unit_price
    end
    prices.each do |price|
      prices_minused_and_squared << (price - mean) ** 2
    end
    x = (prices_minused_and_squared.reduce(:+)/(prices.count - 1.to_f))
    Math.sqrt(x).round(2)
  end

  def golden_items
    golden_item_price = (average_item_price_standard_deviation * 2) + average_average_price_per_merchant
    sales_engine.items.item_array.find_all do |item|
      item.unit_price > golden_item_price
    end
  end

  def average_invoices_per_merchant
    #go through each merchant and count the num of invoices and add them together and divide by amount of invoices total
    merchant_invoices = []
    sales_engine.merchants.merchant_array.each do |merchant|
      merchant_invoices << merchant.invoices.count
    end
    (merchant_invoices.reduce(:+)/merchant_invoices.count.to_f).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    
  end



end
