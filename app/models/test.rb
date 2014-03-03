class Test < ActiveRecord::Base
  attr_accessible :score, :user_id

  has_many :words
end
