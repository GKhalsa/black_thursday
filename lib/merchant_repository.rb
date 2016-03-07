require 'csv'
require_relative 'merchants'
require 'pry'
require_relative 'loader'

class MerchantRepository
  attr_reader :merchant_array, :sales_engine
  def initialize(sales_engine)
    @sales_engine ||= sales_engine
    @merchant_array = []
  end

  def items_from_item_repo(id)
    items = sales_engine.items.item_array
    items.find_all { |item| item.merchant_id == id }
  end

  def invoices_from_invoice_repo(id)
    invoices = sales_engine.invoices.invoice_array
    invoices.find_all { |invoice| invoice.merchant_id == id }
  end

  def inspect
    "#<#{self.class} #{@merchant_array.size} rows>"
  end

  def all
    merchant_array
  end

  def find_by_name(name)
    merchant_array.find { |merchant_object| merchant_object.name.downcase == name.downcase}
  end

  def find_by_id(id)
    merchant_array.find do |merchant_object|
      merchant_object.id == id
    end
  end

  def find_all_by_name(name_fragment)
    merchant_array.find_all do |merchant_object|
      merchant_object.name.downcase.include?(name_fragment.downcase)
    end
  end

  def load_csv(merchants_file)
    if merchant_array.empty?
      contents = FileLoader.load_csv(merchants_file)
      csv_contents_loader(contents)
    end
  end

  def csv_contents_loader(contents)
    contents.each do |row|
      id = row[:id].to_i
      name = row[:name]
      @merchant_array << Merchant.new({
                        :id   => id,
                        :name => name}, self)
    end
  end

end
