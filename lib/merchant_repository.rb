require 'csv'
require_relative 'merchants'
require 'pry'

class MerchantRepository
  attr_reader :merchant_array, :sales_engine
  def initialize(sales_engine)
    @sales_engine ||= sales_engine
    @merchant_array = []  #{:name => 'hello', :id => 123242}
  end

  def items_from_item_repo
    sales_engine.items.item_array
  end

  def invoices_from_invoice_repo
    sales_engine.invoices.invoice_array
  end

  def inspect
    "#<#{self.class} #{@merchant_array.size} rows>"
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

  def all
    merchant_array
  end

  def load_csv(merchants_file)
    contents = CSV.open "#{merchants_file}", headers: true, header_converters: :symbol
    contents.each do |row|
      id = row[:id].to_i
      name = row[:name]
      @merchant_array << Merchant.new({:id => id, :name => name}, self)
    end
  end

end
