class Department < ApplicationRecord

	belongs_to :scores#, through: :subjects
	has_many :subjects

	def scores
		Department.joins(:subjects=> :scores)
	end
end
