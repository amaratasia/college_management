class Score < ApplicationRecord
  belongs_to :exam
  belongs_to :subject
  belongs_to :user
end
