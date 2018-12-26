class Summary < ApplicationRecord
  has_many :users, dependent: :delete_all
end
