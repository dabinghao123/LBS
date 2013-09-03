class Customer < ActiveRecord::Base
  attr_accessible :lng, :lat, :name, :nickname, :tel,:address,:province_id
  belongs_to :province

end
