require_relative "item_repository"
require_relative "merchant_repository"
require 'pry'

class SalesEngine
  attr_reader :items, :merchants

  def initialize(items,merchants)
    @items = items
    @merchants = merchants
  end

  def self.from_csv(csv_hash)
    items = ItemRepository.new(csv_hash[:items])
    merchants = MerchantRepository.new(csv_hash[:merchants])
    SalesEngine.new(items, merchants)
  end

end
