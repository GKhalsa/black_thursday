class Merchants
  attr_accessor :name, :id, :merchant_repo

  def initialize(hash, merchant_repo) #{:name => 'hello', :id => 123242}
    @name = hash[:name]
    @id = hash[:id]
    @merchant_repo = merchant_repo
  end

  def items
    merchant_repo.selling_items
  end

end
