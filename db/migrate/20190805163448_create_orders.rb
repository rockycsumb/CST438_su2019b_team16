class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :itemId
      t.string :description
      t.integer :customerId
      t.integer :price
      t.integer :award
      t.integer :total

      t.timestamps
    end
  end
end
