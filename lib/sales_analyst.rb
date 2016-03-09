require 'pry'
require 'time'
require_relative 'merchant_analytics'
require_relative 'item_analytics'
require_relative 'invoice_analytics'

class SalesAnalyst
  attr_reader :sales_engine, :merchant_invoices,
              :merchant_analytics, :item_analytics,
              :invoice_analytics

  def initialize(sales_engine)
    @sales_engine     ||= sales_engine
    @merchant_analytics = MerchantAnalytics.new(sales_engine)
    @item_analytics     = ItemAnalytics.new(sales_engine)
    @invoice_analytics  = InvoiceAnalytics.new(sales_engine)
  end

  def merchant_array
    sales_engine.merchants.merchant_array
  end

  def item_array
    sales_engine.items.item_array
  end

  def average_items_per_merchant
    merchant_analytics.average_items_per_merchant
  end

  def num_of_items_per_merchant
    merchant_analytics.num_of_items_per_merchant
  end

  def invoice_array
    sales_engine.invoices.invoice_array
  end

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

  def average_item_price_standard_deviation
    item_analytics.average_item_price_standard_deviation
  end

  def golden_items
    item_analytics.golden_items
  end

  def average_invoices_per_merchant
    merchant_analytics.average_invoices_per_merchant
  end

  def average_invoices_per_merchant_standard_deviation
    merchant_analytics.average_invoices_per_merchant_standard_deviation
  end

  def top_merchants_by_invoice_count
    merchant_analytics.top_merchants_by_invoice_count

  end

  def bottom_merchants_by_invoice_count
    merchant_analytics.bottom_merchants_by_invoice_count
  end

  def top_day_deviation
    invoice_analytics.top_day_deviation
  end

  def top_days_by_invoice_count
    invoice_analytics.top_days_by_invoice_count
  end

  def invoice_status(status)
    invoice_analytics.invoice_status(status)
  end

  def total_revenue_by_date(date)
    invoice_analytics.total_revenue_by_date(date)
  end

  def top_revenue_earners(number_of = 20)
    merchant_analytics.top_revenue_earners(number_of) 
  end

  def merchants_ranked_by_revenue
    merchant_analytics.merchants_ranked_by_revenue
    #DO WHAT HORACE DID FOR HASHSES HERE!
  end

  def merchants_with_pending_invoices
    merchant_analytics.merchants_with_pending_invoices
  end

  def merchants_with_only_one_item
    merchant_analytics.merchants_with_only_one_item
  end

  def merchants_with_only_one_item_registered_in_month(month)
    merchant_analytics.merchants_with_only_one_item_registered_in_month(month)
  end

  def revenue_by_merchant(id)
    merchant_analytics.revenue_by_merchant(id)
  end

  def most_sold_item_for_merchant(id)
    merchant_analytics.most_sold_item_for_merchant(id)
  end

  def best_item_for_merchant(id)
    merchant_analytics.best_item_for_merchant(id)
  end

end
