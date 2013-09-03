class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :address
      t.float :lat
      t.float :lng
      t.string :tel
      t.string :typename
      t.string :phone

      t.timestamps
    end
  end
end
