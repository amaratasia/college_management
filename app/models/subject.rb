class Subject < ApplicationRecord
  belongs_to :department
  has_many :scores
end
