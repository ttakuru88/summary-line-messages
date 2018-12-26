class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def active_rates
    @active_rates ||= 24.times.map do |h|
      if messages_count.zero?
        [h, 0]
      else
        [h, messages_count_per_hour[h] / messages_count.to_f * 100]
      end
    end.to_h
  end
end
