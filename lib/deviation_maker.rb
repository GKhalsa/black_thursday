module Deviator

  def awesome_deviation_maker(mean, items) #1 and #2
    pre_deviation = (items.reduce(0) do |acc, avg_num|
      acc + ((avg_num - mean) ** 2)
    end)/(items.count - 1).to_f

    Math.sqrt(pre_deviation).round(2)
  end

end
