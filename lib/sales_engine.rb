require 'pry'
require_relative 'merchant_repository'
require_relative 'item_repository'

class SalesEngine
  attr_reader :merchant_repo, :item_repo

  def initialize(items_file, merchants_file)
    @merchant_repo = MerchantRepository.new(self)
    @item_repo = ItemRepository.new(self)
    csv_loader(items_file, merchants_file)
    #create and itemsReposti
  end

  def csv_loader(items_file, merchants_file)
    merchant_repo.load_csv(merchants_file)
    item_repo.load_csv(items_file)
  end

  def self.from_csv(csv_data)
    SalesEngine.new(csv_data[:items], csv_data[:merchants])
  end

end
