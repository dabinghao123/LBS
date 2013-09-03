class AddCustomers < ActiveRecord::Migration
  def up
    add_column :customers, :lat, :decimal ,:precision =>10,:scale=>6
    add_column :customers, :lng, :decimal ,:precision =>10,:scale=>6
    add_column :customers,:province_id,:integer
  end

  def down
  end
end
