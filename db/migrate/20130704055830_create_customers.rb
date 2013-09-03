class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :tel
      t. :lng
      t.float :lat
      t.string :nickname
      t.string :address
      t.timestamps
    end
  end
end
