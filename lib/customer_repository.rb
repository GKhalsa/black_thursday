require 'csv'
require_relative 'customer'
require 'bigdecimal'
require 'pry'
require_relative 'loader'

class CustomerRepository
  attr_reader :customer_array, :sales_engine

  def initialize(sales_engine)
    @customer_array = []
    @sales_engine ||= sales_engine
  end

  def inspect
    "#<#{self.class} #{@customer_array.size} rows>"
  end

  def merchants_from_merchant_repo
    sales_engine.merchants.merchant_array
  end

  def invoices_from_invoice_repo
    sales_engine.invoices.invoice_array
  end

  def all
    customer_array
  end

  def find_by_id(id)
    customer_array.find do |customer|
      customer.id == id
    end
  end

  def find_all_by_first_name(first_name)
    customer_array.find_all do |customer|
      customer.first_name.downcase.include?(first_name.downcase)
    end
  end

  def find_all_by_last_name(last_name)
    customer_array.find_all do |customer|
      customer.last_name.downcase.include?(last_name.downcase)
    end
  end

  def load_csv(customers_file)
    if customer_array.empty?
      contents = FileLoader.load_csv(customers_file)
      csv_contents_parser(contents)
    end
  end

  def instance_generator(data)
    @customer_array << Customer.new({
            id: data[0], first_name: data[1],
            last_name: data[2], created_at: data[3],
            updated_at: data[4]},self)

  end

  def csv_contents_parser(contents)
    contents.each do |row|
      data = []
      data << row[:id].to_i
      data << row[:first_name]
      data << row[:last_name]
      data << Time.parse(row[:created_at])
      data << Time.parse(row[:updated_at])
      instance_generator(data)
    end
  end

end
