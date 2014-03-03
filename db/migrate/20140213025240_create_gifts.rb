class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.string :name
      t.string :url
      t.integer :score_cost
      t.integer :transaction_id
      t.integer :sender_id
      t.integer :receiver_id

      t.timestamps
    end
  end
end
