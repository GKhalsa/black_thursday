require 'csv'
require_relative 'merchants'

class MerchantRepository
  attr_reader :merchants
  def initialize
    @merchants = []  #{:name => 'hello', :id => 123242}
  end

  def find_by_name(name)
    merchants.find { |merchant_object| merchant_object.name == name}
  end

  def find_by_id(id)
    object = merchants.find do |merchant_object|
      merchant_object.id == id
    end
    object
  end

  def find_all_by_name(name_fragment)
    object = merchants.find_all do |merchant_object|
      merchant_object.name.downcase.include?(name_fragment)
    end
    object
  end

  def all
    merchants
  end

  def load_csv(merchants_file)
    contents = CSV.open ".#{merchants_file}", headers: true, header_converters: :symbol
    contents.each do |row|
      id = row[:id]
      name = row[:name]
      @merchants << Merchants.new({:id => id, :name => name})
    end
  end

end
