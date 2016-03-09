require_relative 'deviation_maker'

class MerchantAnalytics
  attr_reader :sales_engine
  include Deviator

  def initialize(sales_engine)
    @sales_engine ||= sales_engine
    @deviation      = (average_invoices_per_merchant_standard_deviation * 2)
    @avg_invc       = average_invoices_per_merchant
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

  def average_items_per_merchant
    ((item_array.count)/(merchant_array.count.to_f)).round(2)
  end

  def average_average_price_per_merchant
    avg_total = average_merchant_prices.reduce(:+)
    (avg_total/average_merchant_prices.count).round(2)
  end

  def average_merchant_prices
    merchant_array.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
  end

  def average_item_price_for_merchant(merchant_id)
    merchant = fetch_merchant(merchant_id)
    unrounded = (merchant.items.reduce(0) do |sum, item|
      sum += item.unit_price
    end)/(merchant.items.count)
    unrounded.round(2)
  end

  def num_of_items_per_merchant
    merchant_array.map {|merchant| merchant.items.count}
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

  def fetch_merchant(id)
    sales_engine.merchants.find_by_id(id)
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
    merchant_array.find_all do |merchant|
      merchant.invoices.count > (@deviation + @avg_invc)
    end
  end

  def bottom_merchants_by_invoice_count
    merchant_array.find_all do |merchant|
      merchant.invoices.count < (@avg_invc - @deviation)
    end
  end

  def top_revenue_earners(number_of = 20)
    rev_rank = merchants_ranked_by_revenue
    rev_rank[0..(number_of - 1)]
  end

  def merchants_ranked_by_revenue
    merchant_array.sort_by do |merchant_object|
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
