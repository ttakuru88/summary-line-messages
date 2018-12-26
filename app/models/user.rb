class User < ApplicationRecord
  belongs_to :summary

  def message_count_per_hour=(array)
    super(array.join(','))
  end

  def message_count_per_hour
    super.to_s.split(',').map(&:to_i)
  end
end
