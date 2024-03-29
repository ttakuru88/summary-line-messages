class User < ApplicationRecord
  belongs_to :summary

  serialize :messages_count_per_hour, Array
  serialize :count_per_pickup_word, Hash

  delegate :pickup_words, to: :summary
end
