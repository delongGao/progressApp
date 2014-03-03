class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :subtotal
      t.integer :sponsor_id
      t.datetime :date

      t.timestamps
    end
  end
end
