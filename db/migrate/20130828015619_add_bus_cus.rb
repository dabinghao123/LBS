class AddBusCus < ActiveRecord::Migration
  def up
  	add_column :businesses, :lat, :decimal ,:precision =>10,:scale=>6
    add_column :businesses, :lng, :decimal ,:precision =>10,:scale=>6
    add_column :businesses, :province_id ,:integer
    # add_column :customers, :lat, :decimal ,:precision =>10,:scale=>6
    # add_column :customers, :lng, :decimal ,:precision =>10,:scale=>6
    # add_column :customers,:province_id,:integer
  end

  def down
  
  	 # remove_column :businesses, :lng
    #  remove_column :businesses, :lat
    #  remove_column :customers, :lng
    #  remove_column :customers, :lat
  end
end
