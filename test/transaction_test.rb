require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/transaction'

class TransactionTest < Minitest::Test
  attr_reader :t

  def setup
    @t = Transaction.new({
      :id => 6,
      :invoice_id => 8,
      :credit_card_number => "4242424242424242",
      :credit_card_expiration_date => "0220",
      :result => "success",
      :created_at => Time.now,
      :updated_at => Time.now
    })
  end

  def test_that_transaction_exists
    assert_equal Transaction, t.class
  end

  def test_that_transaction_has_a_id
    assert_equal 6, t.id
  end

  def test_that_t_has_a_invoice_id
    assert_equal 8, t.invoice_id
  end

  def test_that_t_has_a_credit_card_number
    assert_equal "4242424242424242", t.credit_card_number
  end

  def test_that_t_has_a_credit_card_expiration_date
    assert_equal "0220", t.credit_card_expiration_date
  end

  def test_that_t_has_a_result
    assert_equal "success", t.result
  end

  def test_that_t_has_a_creation_date
    assert_equal Time, t.created_at.class
  end

  def test_that_t_has_a_updated_date
    assert_equal Time, t.updated_at.class
  end

end
