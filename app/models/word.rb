class Word < ActiveRecord::Base
  attr_accessible :content, :total_times, :correct_times, :score

  has_one :answer, dependent: :destroy

  belongs_to :report
  belongs_to :test
end
