class Summary < ApplicationRecord
  has_many :users, dependent: :delete_all

  before_create :generate_uuid

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid if uuid.blank?
  end
end
