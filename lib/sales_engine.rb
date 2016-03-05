require 'pry'
require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'


class SalesEngine
  attr_reader :merchants, :items, :invoices, :invoice_items

  def initialize(items_file, merchants_file, invoice_file, invoice_item_file)
    @merchants = MerchantRepository.new(self)
    @items = ItemRepository.new(self)
    @invoices = InvoiceRepository.new(self)
    @invoice_items = InvoiceItemRepository.new
    csv_loader(items_file, merchants_file, invoice_file, invoice_item_file)
  end

  def csv_loader(items_file, merchants_file, invoice_file, invoice_item_file)
    merchants.load_csv(merchants_file)
    items.load_csv(items_file)
    invoices.load_csv(invoice_file)
    invoice_items.load_csv(invoice_item_file)
  end

  def self.from_csv(csv_data)
    SalesEngine.new(csv_data[:items], csv_data[:merchants], csv_data[:invoices], csv_data[:invoice_items])
  end

end
