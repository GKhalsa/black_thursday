require 'pry'
require 'time'

class SalesAnalyst
  attr_reader :sales_engine,
              :merchant_invoices

  def initialize(sales_engine)
    @sales_engine ||= sales_engine
  end

  def merchant_array
    sales_engine.merchants.merchant_array
  end

  def item_array
    sales_engine.items.item_array
  end

  def average_items_per_merchant
    ((item_array.count)/(merchant_array.count.to_f)).round(2)
  end

  def num_of_items_per_merchant
    merchant_array.map {|merchant| merchant.items.count}
  end

  def fetch_merchant(id)
    sales_engine.merchants.find_by_id(id)
  end

  def invoice_array
    sales_engine.invoices.invoice_array
  end

  def average_items_per_merchant_standard_deviation
    mean = average_items_per_merchant
    items = num_of_items_per_merchant
    awesome_deviation_maker(mean,items)
  end


  def merchants_with_high_item_count
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

  def average_merchant_prices
    merchant_array.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
  end

  def average_average_price_per_merchant
    avg_total = average_merchant_prices.reduce(:+)
    (avg_total/average_merchant_prices.count).round(2)
  end

  def average_item_price_standard_deviation
    mean = average_average_price_per_merchant
    items = item_array.map(&:unit_price)
    awesome_deviation_maker(mean,items)
  end

  def awesome_deviation_maker(mean, items)
    pre_deviation = (items.reduce(0) do |acc, avg_num|
      acc + ((avg_num - mean) ** 2)
    end)/(items.count - 1).to_f

    Math.sqrt(pre_deviation).round(2)
  end

  def golden_items
    deviation = (average_item_price_standard_deviation * 2)
    golden_price = deviation + average_average_price_per_merchant
    item_array.find_all do |item|
      item.unit_price > golden_price
    end
  end

  def average_invoices_per_merchant
    ((invoice_array.count)/(merchant_array.count.to_f)).round(2)
  end

  def invoices_per_merchant
    merchant_array.map { |merchant| merchant.invoices.count }
  end

  def average_invoices_per_merchant_standard_deviation
    mean = average_invoices_per_merchant
    invoices = invoices_per_merchant
    awesome_deviation_maker(mean, invoices)
  end

  def top_merchants_by_invoice_count
    top_performer_num = (average_invoices_per_merchant_standard_deviation * 2) + average_invoices_per_merchant

    merchant_array.find_all do |merchant|
      merchant.invoices.count > top_performer_num
    end
  end

  def bottom_merchants_by_invoice_count
    bottom_performer_num = average_invoices_per_merchant - (average_invoices_per_merchant_standard_deviation * 2)

    merchant_array.find_all do |merchant|
      merchant.invoices.count < bottom_performer_num
    end
  end

  def invoice_count_per_day_hash
    invoice_array.reduce(Hash.new(0)) do |days, invoice|
      invoice_day = invoice.created_at.strftime("%A")
      days[invoice_day] += 1
      days
    end
  end

  def top_days_by_invoice_count
    mean = (invoice_array.count / 7).to_f
    invoices_per_day = invoice_count_per_day_hash.values

    day_deviation = awesome_deviation_maker(mean, invoices_per_day)
    invoice_count_per_day_hash.find_all do |day,count|
      count > (mean + day_deviation)
    end.map {|day, count| day}
  end

  def invoice_status(status)
    matching_invoice_array = invoice_array.find_all do |invoice|
      invoice.status == status
    end
    percentage(matching_invoice_array)
  end

  def percentage(matching_status)
    x = ((matching_status.count.to_f)/(invoice_array.count))
    (x * 100).round(2)
  end

  def total_revenue_by_date(date)
    invoices = sales_engine.invoices.find_all_by_created_at(date)
    invoices.reduce(0) do |sum, invoice|
      sum += invoice.total
    end
  end

  def top_revenue_earners(number_of = 20)
    x = sales_engine.merchants.merchant_array
    x.sort_by do |merchant_object|
      merchant_object.merchant_total_revenue
    end.reverse[0..(number_of - 1)]
  end

  def merchants_ranked_by_revenue
    x = sales_engine.merchants.merchant_array
    x.sort_by do |merchant_object|
      merchant_object.merchant_total_revenue
    end.reverse
  end

  def merchants_with_pending_invoices
    merchant_array.find_all do |merchant|
      merchant.are_invoices_pending?
    end
  end

  def merchants_with_only_one_item
    merchant_array.find_all do |merchant|
      merchant.items.count == 1
    end
  end

  def merchants_with_only_one_item_registered_in_month(month)
    merchant_array.find_all do |merchant|
      merchant.creation_date_items(month) == 1
    end
  end

  def revenue_by_merchant(id)
    merchant = sales_engine.merchants.find_by_id(id)
    merchant.total_revenue
  end

  def most_sold_item_for_merchant(id)
    merchant = sales_engine.merchants.find_by_id(id)
    merchant.most_sold_item
  end

  def best_item_for_merchant(id)
    merchant = sales_engine.merchants.find_by_id(id)
    merchant.best_item_sales
  end


end
