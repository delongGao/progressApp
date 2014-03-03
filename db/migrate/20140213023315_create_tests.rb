class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.integer :score
      t.integer :user_id

      t.timestamps
    end
  end
end
