class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.belongs_to :summary, index: true, foreign_key: true
      t.string :name
      t.integer :messages_count, default: 0
      t.integer :kusas_count, default: 0
      t.integer :stamps_count, default: 0
      t.integer :photos_count, default: 0
      t.date :start_at
      t.date :end_at
      t.text :messages_count_per_hour
      t.text :count_per_pickup_word
    end
  end
end
