require 'pry'
require 'time'

class SalesAnalyst
  attr_reader :sales_engine, :merchant_invoices,
              :merchant_analytics

  def initialize(sales_engine)
    @sales_engine ||= sales_engine
    @merchant_analytics = MerchantAnalytics.new(sales_engine)
    @deviation = (average_invoices_per_merchant_standard_deviation * 2)
    @avg_invc = average_invoices_per_merchant
  end

  def merchant_array #used
    sales_engine.merchants.merchant_array
  end

  def average_items_per_merchant
    merchant_analytics.average_items_per_merchant
  end

  def num_of_items_per_merchant
    merchant_analytics.num_of_items_per_merchant
  end

  # def invoice_array
  #   sales_engine.invoices.invoice_array
  # end

  def average_items_per_merchant_standard_deviation
    merchant_analytics.average_items_per_merchant_standard_deviation
  end

  def merchants_with_high_item_count
    merchant_analytics.merchants_with_high_item_count
  end

  def average_item_price_for_merchant(merchant_id)
    merchant_analytics.average_item_price_for_merchant(merchant_id)
  end


  def average_average_price_per_merchant
    merchant_analytics.average_average_price_per_merchant
  end

  def average_item_price_standard_deviation #2 link1
    mean = average_average_price_per_merchant
    items = item_array.map(&:unit_price)
    awesome_deviation_maker(mean,items)
  end

  def awesome_deviation_maker(mean, items) #1 and #2
    pre_deviation = (items.reduce(0) do |acc, avg_num|
      acc + ((avg_num - mean) ** 2)
    end)/(items.count - 1).to_f

    Math.sqrt(pre_deviation).round(2)
  end

  def golden_items #2 link1
    deviation = (average_item_price_standard_deviation * 2)
    golden_price = deviation + average_average_price_per_merchant
    item_array.find_all do |item|
      item.unit_price > golden_price
    end
  end

  def average_invoices_per_merchant
    merchant_analytics.average_invoices_per_merchant
  end



  def average_invoices_per_merchant_standard_deviation #1
    merchant_analytics.average_invoices_per_merchant_standard_deviation
  end

  def top_merchants_by_invoice_count #1
    merchant_array.find_all do |merchant|
      merchant.invoices.count > (@deviation + @avg_invc)
    end
  end

  def bottom_merchants_by_invoice_count #1
    merchant_array.find_all do |merchant|
      merchant.invoices.count < (@avg_invc - @deviation)
    end
  end

  def invoice_count_per_day_hash #3
    invoice_array.reduce(Hash.new(0)) do |days, invoice|
      invoice_day = invoice.created_at.strftime("%A")
      days[invoice_day] += 1
      days
    end
  end

  def top_day_deviation #3
    @mean = (invoice_array.count / 7).to_f
    invoices_per_day = invoice_count_per_day_hash.values
    day_deviation = awesome_deviation_maker(@mean, invoices_per_day)
  end

  def top_days_by_invoice_count #3
    day_deviation = top_day_deviation
    invoice_count_per_day_hash.find_all do |day,count|
      count > (@mean + day_deviation)
    end.map {|day, count| day}
  end

  def invoice_status(status) #3
    matching_invoice_array = invoice_array.find_all do |invoice|
      invoice.status == status
    end
    percentage(matching_invoice_array)
  end

  def percentage(matching_status) #3
    x = ((matching_status.count.to_f)/(invoice_array.count))
    (x * 100).round(2)
  end

  def total_revenue_by_date(date) #3
    invoices = sales_engine.invoices.find_all_by_created_at(date)
    invoices.reduce(0) do |sum, invoice|
      sum += invoice.total
    end
  end

  def top_revenue_earners(number_of = 20) #1
    rev_rank = merchants_ranked_by_revenue
    rev_rank[0..(number_of - 1)]
  end

  def merchants_ranked_by_revenue #1
    merchant_array.sort_by do |merchant_object|
      merchant_object.merchant_total_revenue
    end.reverse
  end

  def merchants_with_pending_invoices #1
    merchant_array.find_all do |merchant|
      merchant.are_invoices_pending?
    end
  end

  def merchants_with_only_one_item #1
    merchant_array.find_all do |merchant|
      merchant.items.count == 1
    end
  end

  def merchants_with_only_one_item_registered_in_month(month) #1
    merchant_array.find_all do |merchant|
      merchant.creation_date_items(month) == 1
    end
  end

  def revenue_by_merchant(id) #1
    merchant = sales_engine.merchants.find_by_id(id)
    merchant.total_revenue
  end

  def most_sold_item_for_merchant(id) #1
    merchant = sales_engine.merchants.find_by_id(id)
    merchant.most_sold_item
  end

  def best_item_for_merchant(id) #1
    merchant = sales_engine.merchants.find_by_id(id)
    merchant.best_item_sales
  end

end

class MerchantAnalytics
  attr_reader :sales_engine
  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def merchant_array
    sales_engine.merchants.merchant_array
  end

  def item_array
    sales_engine.items.item_array
  end

  def invoice_array
    sales_engine.invoices.invoice_array
  end

  def average_items_per_merchant  #1
    ((item_array.count)/(merchant_array.count.to_f)).round(2)
  end

  def num_of_items_per_merchant #1
    merchant_array.map {|merchant| merchant.items.count}
  end

  def average_items_per_merchant_standard_deviation # 1
    mean = average_items_per_merchant
    items = num_of_items_per_merchant
    awesome_deviation_maker(mean,items)
  end

  def awesome_deviation_maker(mean, items)
    pre_deviation = (items.reduce(0) do |acc, avg_num|
      acc + ((avg_num - mean) ** 2)
    end)/(items.count - 1).to_f

    Math.sqrt(pre_deviation).round(2)
  end

  def merchants_with_high_item_count   #1
    deviation = average_items_per_merchant_standard_deviation
    high_item_count = average_items_per_merchant + deviation

    merchant_array.find_all do |merchant|
      merchant.items.count > high_item_count
    end
  end

  def average_item_price_for_merchant(merchant_id)
    merchant = fetch_merchant(merchant_id)
    unrounded = (merchant.items.reduce(0) do |sum, item|
      sum += item.unit_price.to_f
    end)/(merchant.items.count)
    unrounded.round(2)
  end

  def fetch_merchant(id)
    sales_engine.merchants.find_by_id(id)
  end


  def average_merchant_prices #1
    merchant_array.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
  end

  def average_average_price_per_merchant #1
    avg_total = average_merchant_prices.reduce(:+)
    (avg_total/average_merchant_prices.count).round(2)
  end

  def average_invoices_per_merchant #1
    ((invoice_array.count)/(merchant_array.count.to_f)).round(2)
  end

  def invoices_per_merchant #1 link 2
    merchant_array.map { |merchant| merchant.invoices.count }
  end

  def average_invoices_per_merchant_standard_deviation #1
    mean = average_invoices_per_merchant
    invoices = invoices_per_merchant
    awesome_deviation_maker(mean, invoices)
  end

end
