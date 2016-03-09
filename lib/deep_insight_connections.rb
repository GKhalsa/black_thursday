class DeepInsight
  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def customers
    sales_engine.customers.customer_array
  end

  def jewish_customer_object_array
    names = ["ski","nader","witz","berg","baum","hyatt","burg","man"]
    names.map do |name|
      the_gathering_of_the_jews(name)
    end.flatten
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

end
