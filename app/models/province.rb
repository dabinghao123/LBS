class Province < ActiveRecord::Base
  attr_accessible :city, :province
  has_many :customers
  has_many :businesses
end
