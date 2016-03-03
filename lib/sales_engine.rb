require 'pry'
require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'invoice_repository'


class SalesEngine
  attr_reader :merchants, :items, :invoices

  def initialize(items_file, merchants_file, invoice_file)
    @merchants = MerchantRepository.new(self)
    @items = ItemRepository.new(self)
    @invoices = InvoiceRepository.new(self)
    csv_loader(items_file, merchants_file, invoice_file)
  end

  def csv_loader(items_file, merchants_file, invoice_file)
    merchants.load_csv(merchants_file)
    items.load_csv(items_file)
    invoices.load_csv(invoice_file)
  end

  def self.from_csv(csv_data)
    SalesEngine.new(csv_data[:items], csv_data[:merchants], csv_data[:invoices])
  end

end
