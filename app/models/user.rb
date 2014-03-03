class User < ActiveRecord::Base
  attr_accessible :credit, :email, :type

  has_many :tests, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :gifts, dependent: :destroy
  has_many :transaction, dependent: :destroy
end
