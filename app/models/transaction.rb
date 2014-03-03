class Transaction < ActiveRecord::Base
  attr_accessible :date, :sponsor_id, :subtotal

  has_many :gifts, dependent: :destroy
end
