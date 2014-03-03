class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :content
      t.integer :total_times
      t.integer :correct_times
      t.integer :score
      t.integer :answer_id

      t.timestamps
    end
  end
end
