require 'pry'
require 'time'

class SalesAnalyst
  attr_reader :sales_engine, :items_per_merchant,
              :average_average_prices, :merchant_invoices

  def initialize(sales_engine)
    @sales_engine ||= sales_engine
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
    @merchant_invoices = []
    sales_engine.merchants.merchant_array.each do |merchant|
      merchant_invoices << merchant.invoices.count
    end
    (merchant_invoices.reduce(:+)/merchant_invoices.count.to_f).round(2)
  end


  def average_invoices_per_merchant_standard_deviation
    mean = average_invoices_per_merchant
    invoices = merchant_invoices
    awesome_deviation_maker(mean, invoices)
  end

  def top_merchants_by_invoice_count
    top_performer_num = (average_invoices_per_merchant_standard_deviation * 2) + average_invoices_per_merchant

    sales_engine.merchants.merchant_array.find_all do |merchant|
      merchant.invoices.count > top_performer_num
    end
  end

  def bottom_merchants_by_invoice_count
    bottom_performer_num = average_invoices_per_merchant - (average_invoices_per_merchant_standard_deviation * 2)

    sales_engine.merchants.merchant_array.find_all do |merchant|
      merchant.invoices.count < bottom_performer_num
    end
  end

  def awesome_deviation_maker(mean, avg_items)
    pre_deviation = (avg_items.reduce(0) do |acc, avg_num|
      acc + ((avg_num - mean) ** 2)
    end)/(avg_items.count - 1).to_f

    Math.sqrt(pre_deviation).round(2)
  end

  def invoice_count_per_day_hash
    sales_engine.invoices.invoice_array.reduce(Hash.new(0)) do |days, invoice|
      invoice_day = invoice.created_at.strftime("%A")
      days[invoice_day] += 1
      days
    end
  end

  def top_days_by_invoice_count
    mean = (sales_engine.invoices.invoice_array.count / 7).to_f
    invoices_per_day = invoice_count_per_day_hash.values

    day_deviation = awesome_deviation_maker(mean, invoices_per_day)
    invoice_count_per_day_hash.find_all do |day,count|
      count > (mean + day_deviation)
    end.map {|day, count| day}
  end

  def invoice_status(status)
    array_of_invoices = sales_engine.invoices.invoice_array
    matching_invoice_array = array_of_invoices.find_all do |invoice|
      invoice.status == status
    end
   percentage = ((matching_invoice_array.count.to_f)/(array_of_invoices.count))
   (percentage * 100).round(2)
  end

  def total_revenue_by_date(date)
    invoices = sales_engine.invoices.find_all_by_created_at(date)
    invoices.reduce(0) do |sum, invoice|
      sum += invoice.total
    end
  end

  def top_revenue_earners(number_of = 20)
    x = sales_engine.merchants.merchant_array.map do |merchant|
      merchant.total_revenue
      merchant
    end
    x.sort_by do |merchant_object|
      -merchant_object.merchant_total_revenue
    end[0..(number_of - 1)]
  end

  def merchants_with_pending_invoices
    sales_engine.merchants.merchant_array.find_all do |merchant|
      merchant.are_invoices_pending?
    end
  end

  def merchants_with_only_one_item

  end



end
