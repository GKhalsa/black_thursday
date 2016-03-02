class Merchants
  attr_accessor :name, :id

  def initialize(hash) #{:name => 'hello', :id => 123242}
    @name = hash[:name]
    @id = hash[:id]
  end

end
