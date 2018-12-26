class CreateSummaries < ActiveRecord::Migration[5.2]
  def change
    create_table :summaries do |t|
      t.string :name
      t.string :uuid, null: false, index: {unique: true}
      t.date :start_at
      t.date :end_at
      t.timestamps
    end
  end
end
