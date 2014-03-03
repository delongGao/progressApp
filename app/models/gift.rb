class Gift < ActiveRecord::Base
  attr_accessible :name, :receiver_id, :score_cost, :sender_id, :transaction_id, :url
end
