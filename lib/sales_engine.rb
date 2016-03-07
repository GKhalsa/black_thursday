require 'pry'
require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'transaction_repository'
require_relative 'customer_repository'


class SalesEngine
  attr_reader :merchants, :items, :invoices, :invoice_items, :transactions, :customers

  def initialize(items_file, merchants_file, invoice_file, invoice_item_file, transactions_file, customers_file)
    @merchants ||= MerchantRepository.new(self)
    @items ||= ItemRepository.new(self)
    @invoices ||= InvoiceRepository.new(self)
    @invoice_items ||= InvoiceItemRepository.new(self)
    @transactions ||= TransactionRepository.new(self)
    @customers ||= CustomerRepository.new(self)
    csv_loader(items_file, merchants_file, invoice_file, invoice_item_file, transactions_file, customers_file)
  end

  def csv_loader(items_file, merchants_file, invoice_file, invoice_item_file, transactions_file, customers_file)
    merchants.load_csv(merchants_file)
    items.load_csv(items_file)
    invoices.load_csv(invoice_file)
    invoice_items.load_csv(invoice_item_file)
    transactions.load_csv(transactions_file)
    customers.load_csv(customers_file)
  end

  def self.from_csv(csv_data)
    SalesEngine.new(csv_data[:items], csv_data[:merchants], csv_data[:invoices], csv_data[:invoice_items], csv_data[:transactions], csv_data[:customers])
  end

end
