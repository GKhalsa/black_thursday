require 'csv'
require_relative 'customer'
require 'bigdecimal'
require 'pry'

class CustomerRepository
  attr_reader :customer_array

  def initialize
    @customer_array = []
  end

  def inspect
    "#<#{self.class} #{@customer_array.size} rows>"
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
      customer.first_name.include?(first_name)
    end
  end

  def find_all_by_last_name(last_name)
    customer_array.find_all do |customer|
      customer.last_name.include?(last_name)
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
                                     created_at: created_at, updated_at: updated_at})
    end
  end
end
