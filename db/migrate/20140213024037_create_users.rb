class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.integer :type
      t.integer :credit

      t.timestamps
    end
  end
end
