require_relative 'merchant_analytics'
require_relative 'deviation_maker'

class InvoiceAnalytics
  attr_reader :sales_engine
  include Deviator

  def initialize(sales_engine)
    @sales_engine ||= sales_engine
  end

  def invoice_array
    sales_engine.invoices.invoice_array
  end

  def invoice_count_per_day_hash
    invoice_array.reduce(Hash.new(0)) do |days, invoice|
      invoice_day = invoice.created_at.strftime("%A")
      days[invoice_day] += 1
      days
    end
  end

  def top_day_deviation
    @mean = (invoice_array.count / 7).to_f
    invoices_per_day = invoice_count_per_day_hash.values
    day_deviation = awesome_deviation_maker(@mean, invoices_per_day)
  end

  def top_days_by_invoice_count
    day_deviation = top_day_deviation
    invoice_count_per_day_hash.find_all do |day,count|
      count > (@mean + day_deviation)
    end.map {|day, count| day}
  end

  def invoice_status(status)
    matching_invoice_array = invoice_array.find_all do |invoice|
      invoice.status == status
    end
    percentage(matching_invoice_array)
  end

  def percentage(matching_status)
    x = ((matching_status.count.to_f)/(invoice_array.count))
    (x * 100).round(2)
  end

  def total_revenue_by_date(date)
    invoices = sales_engine.invoices.find_all_by_created_at(date)
    invoices.reduce(0) do |sum, invoice|
      sum += invoice.total
    end
  end
end
