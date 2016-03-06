require 'csv'
require_relative 'customer'
require 'bigdecimal'
require 'pry'

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
    contents = CSV.open "#{customers_file}", headers: true, header_converters: :symbol
    contents.each do |row|
      id = row[:id].to_i
      first_name = row[:first_name]
      last_name = row[:last_name]
      created_at = Time.parse(row[:created_at])
      updated_at = Time.parse(row[:updated_at])
      @customer_array << Customer.new({id: id, first_name: first_name, last_name: last_name,
                                     created_at: created_at, updated_at: updated_at},self)
    end
  end
end
