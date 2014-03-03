class Report < ActiveRecord::Base
  attr_accessible :user_id

  has_many :words
end
