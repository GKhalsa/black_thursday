require_relative 'merchant_analytics'
require_relative 'deviation_maker'

class ItemAnalytics < MerchantAnalytics
  attr_reader :sales_engine
  include Deviator

  def initialize(sales_engine)
    @sales_engine ||= sales_engine
  end

  def average_item_price_standard_deviation
    mean = average_average_price_per_merchant
    items = item_array.map(&:unit_price)
    awesome_deviation_maker(mean,items)
  end

  def golden_items
    deviation = (average_item_price_standard_deviation * 2)
    golden_price = deviation + average_average_price_per_merchant
    item_array.find_all do |item|
      item.unit_price > golden_price
    end
  end

end
