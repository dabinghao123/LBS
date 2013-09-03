class Business < ActiveRecord::Base
  attr_accessible :address, :lng, :lat, :name, :phone, :tel,:typename,:province_id
  belongs_to :province
end
