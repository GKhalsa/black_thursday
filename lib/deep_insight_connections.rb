require 'gender_detector'

class DeepInsight
  attr_reader :sales_engine, :customers, :gender_hash,
              :male, :female, :male_pop_day, :female_pop_day

  def initialize(sales_engine)
    @sales_engine ||= sales_engine
    @customers    ||= sales_engine.customers.customer_array
  end

  def jewish_customer_object_array
    names = ["ski","nader","witz","berg","baum","hyatt","burg","man"]
    names.flat_map do |name|
      the_gathering_of_the_jews(name)
    end
  end

  def the_gathering_of_the_jews(name)
    customers.find_all do |customer|
      customer.last_name.downcase.include?(name.downcase)
    end
  end

  def who_broke_the_sabbath?
    x = jewish_customer_object_array.find_all do |customer|
      customer.broke_sabbath?
    end
  end

  def determine_gender(name)
    detector = GenderDetector.new
    detector.get_gender(name)
  end

  def mapping_customer_to_gender
    @gender_hash = {}
    x = customers[0..40]
    y = x.map do |customer|
      gender_hash[customer] = determine_gender(customer.first_name)
    end
  end

  def shopping_days_by_gender
    mapping_customer_to_gender
    @male   = Hash.new(0)
    @female = Hash.new(0)
    @gender_hash.each do |key, value|
      if value == :male
        add_male_days(key,value)
      elsif value == :female
        add_female_days(key,value)
      end
    end
  end

  def add_female_days(key,value)
    days = key.purchasing_days
    days.each do |key, value|
      female[key] += value
    end
  end

  def add_male_days(key,value)
    days = key.purchasing_days
    days.each do |key, value|
      male[key] += value
    end
  end

  def popular_days
    shopping_days_by_gender
    male_pop_num = male.values.max
    @male_pop_day = male.key(male_pop_num)
    female_pop_num = female.values.max
    @female_pop_day = female.key(female_pop_num)
  end

end
