class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.belongs_to :summary, index: true
      t.integer :messages_count, default: 0
      t.integer :kusas_count, default: 0
      t.integer :stamps_count, default: 0
      t.integer :photos_count, default: 0
      t.text :message_count_per_hour
    end
  end
end